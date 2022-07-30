
obj/user/tst_malloc_5:     file format elf32-i386


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
  800031:	e8 69 03 00 00       	call   80039f <libmain>
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
  800096:	e8 49 04 00 00       	call   8004e4 <_panic>
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
  8000eb:	e8 20 14 00 00       	call   801510 <malloc>
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
  80012f:	e8 dc 13 00 00       	call   801510 <malloc>
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

		ptr_allocations[2] = malloc(2*kilo);
  800170:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800173:	01 c0                	add    %eax,%eax
  800175:	83 ec 0c             	sub    $0xc,%esp
  800178:	50                   	push   %eax
  800179:	e8 92 13 00 00       	call   801510 <malloc>
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  800187:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80018d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  800190:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800193:	01 c0                	add    %eax,%eax
  800195:	c1 e8 02             	shr    $0x2,%eax
  800198:	48                   	dec    %eax
  800199:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr[0] = minInt;
  80019c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80019f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001a2:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8001a4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001ae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001b1:	01 c2                	add    %eax,%edx
  8001b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001b6:	89 02                	mov    %eax,(%edx)

		ptr_allocations[3] = malloc(7*kilo);
  8001b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001bb:	89 d0                	mov    %edx,%eax
  8001bd:	01 c0                	add    %eax,%eax
  8001bf:	01 d0                	add    %edx,%eax
  8001c1:	01 c0                	add    %eax,%eax
  8001c3:	01 d0                	add    %edx,%eax
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	50                   	push   %eax
  8001c9:	e8 42 13 00 00       	call   801510 <malloc>
  8001ce:	83 c4 10             	add    $0x10,%esp
  8001d1:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8001d7:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8001dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8001e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001e3:	89 d0                	mov    %edx,%eax
  8001e5:	01 c0                	add    %eax,%eax
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	01 c0                	add    %eax,%eax
  8001eb:	01 d0                	add    %edx,%eax
  8001ed:	c1 e8 03             	shr    $0x3,%eax
  8001f0:	48                   	dec    %eax
  8001f1:	89 45 b8             	mov    %eax,-0x48(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8001f4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001f7:	8a 55 e7             	mov    -0x19(%ebp),%dl
  8001fa:	88 10                	mov    %dl,(%eax)
  8001fc:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8001ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800202:	66 89 42 02          	mov    %ax,0x2(%edx)
  800206:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800209:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80020c:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  80020f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800212:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800219:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80021c:	01 c2                	add    %eax,%edx
  80021e:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800221:	88 02                	mov    %al,(%edx)
  800223:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800226:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80022d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800230:	01 c2                	add    %eax,%edx
  800232:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  800236:	66 89 42 02          	mov    %ax,0x2(%edx)
  80023a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800244:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800247:	01 c2                	add    %eax,%edx
  800249:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80024c:	89 42 04             	mov    %eax,0x4(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  80024f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800252:	8a 00                	mov    (%eax),%al
  800254:	3a 45 e7             	cmp    -0x19(%ebp),%al
  800257:	75 0f                	jne    800268 <_main+0x230>
  800259:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80025c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80025f:	01 d0                	add    %edx,%eax
  800261:	8a 00                	mov    (%eax),%al
  800263:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  800266:	74 14                	je     80027c <_main+0x244>
  800268:	83 ec 04             	sub    $0x4,%esp
  80026b:	68 70 23 80 00       	push   $0x802370
  800270:	6a 42                	push   $0x42
  800272:	68 5c 23 80 00       	push   $0x80235c
  800277:	e8 68 02 00 00       	call   8004e4 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  80027c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80027f:	66 8b 00             	mov    (%eax),%ax
  800282:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  800286:	75 15                	jne    80029d <_main+0x265>
  800288:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80028b:	01 c0                	add    %eax,%eax
  80028d:	89 c2                	mov    %eax,%edx
  80028f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800292:	01 d0                	add    %edx,%eax
  800294:	66 8b 00             	mov    (%eax),%ax
  800297:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  80029b:	74 14                	je     8002b1 <_main+0x279>
  80029d:	83 ec 04             	sub    $0x4,%esp
  8002a0:	68 70 23 80 00       	push   $0x802370
  8002a5:	6a 43                	push   $0x43
  8002a7:	68 5c 23 80 00       	push   $0x80235c
  8002ac:	e8 33 02 00 00       	call   8004e4 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8002b1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002b4:	8b 00                	mov    (%eax),%eax
  8002b6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002b9:	75 16                	jne    8002d1 <_main+0x299>
  8002bb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002c8:	01 d0                	add    %edx,%eax
  8002ca:	8b 00                	mov    (%eax),%eax
  8002cc:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002cf:	74 14                	je     8002e5 <_main+0x2ad>
  8002d1:	83 ec 04             	sub    $0x4,%esp
  8002d4:	68 70 23 80 00       	push   $0x802370
  8002d9:	6a 44                	push   $0x44
  8002db:	68 5c 23 80 00       	push   $0x80235c
  8002e0:	e8 ff 01 00 00       	call   8004e4 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002e5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002e8:	8a 00                	mov    (%eax),%al
  8002ea:	3a 45 e7             	cmp    -0x19(%ebp),%al
  8002ed:	75 16                	jne    800305 <_main+0x2cd>
  8002ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002f2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002f9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002fc:	01 d0                	add    %edx,%eax
  8002fe:	8a 00                	mov    (%eax),%al
  800300:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  800303:	74 14                	je     800319 <_main+0x2e1>
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	68 70 23 80 00       	push   $0x802370
  80030d:	6a 46                	push   $0x46
  80030f:	68 5c 23 80 00       	push   $0x80235c
  800314:	e8 cb 01 00 00       	call   8004e4 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  800319:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80031c:	66 8b 40 02          	mov    0x2(%eax),%ax
  800320:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  800324:	75 19                	jne    80033f <_main+0x307>
  800326:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800329:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800330:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800333:	01 d0                	add    %edx,%eax
  800335:	66 8b 40 02          	mov    0x2(%eax),%ax
  800339:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 70 23 80 00       	push   $0x802370
  800347:	6a 47                	push   $0x47
  800349:	68 5c 23 80 00       	push   $0x80235c
  80034e:	e8 91 01 00 00       	call   8004e4 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800353:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800356:	8b 40 04             	mov    0x4(%eax),%eax
  800359:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80035c:	75 17                	jne    800375 <_main+0x33d>
  80035e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800361:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800368:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80036b:	01 d0                	add    %edx,%eax
  80036d:	8b 40 04             	mov    0x4(%eax),%eax
  800370:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800373:	74 14                	je     800389 <_main+0x351>
  800375:	83 ec 04             	sub    $0x4,%esp
  800378:	68 70 23 80 00       	push   $0x802370
  80037d:	6a 48                	push   $0x48
  80037f:	68 5c 23 80 00       	push   $0x80235c
  800384:	e8 5b 01 00 00       	call   8004e4 <_panic>


	}

	cprintf("Congratulations!! test malloc (5) completed successfully.\n");
  800389:	83 ec 0c             	sub    $0xc,%esp
  80038c:	68 a8 23 80 00       	push   $0x8023a8
  800391:	e8 f0 03 00 00       	call   800786 <cprintf>
  800396:	83 c4 10             	add    $0x10,%esp

	return;
  800399:	90                   	nop
}
  80039a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003a5:	e8 70 17 00 00       	call   801b1a <sys_getenvindex>
  8003aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003b0:	89 d0                	mov    %edx,%eax
  8003b2:	c1 e0 03             	shl    $0x3,%eax
  8003b5:	01 d0                	add    %edx,%eax
  8003b7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003be:	01 c8                	add    %ecx,%eax
  8003c0:	01 c0                	add    %eax,%eax
  8003c2:	01 d0                	add    %edx,%eax
  8003c4:	01 c0                	add    %eax,%eax
  8003c6:	01 d0                	add    %edx,%eax
  8003c8:	89 c2                	mov    %eax,%edx
  8003ca:	c1 e2 05             	shl    $0x5,%edx
  8003cd:	29 c2                	sub    %eax,%edx
  8003cf:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8003d6:	89 c2                	mov    %eax,%edx
  8003d8:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8003de:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e8:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8003ee:	84 c0                	test   %al,%al
  8003f0:	74 0f                	je     800401 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8003f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f7:	05 40 3c 01 00       	add    $0x13c40,%eax
  8003fc:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800401:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800405:	7e 0a                	jle    800411 <libmain+0x72>
		binaryname = argv[0];
  800407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800411:	83 ec 08             	sub    $0x8,%esp
  800414:	ff 75 0c             	pushl  0xc(%ebp)
  800417:	ff 75 08             	pushl  0x8(%ebp)
  80041a:	e8 19 fc ff ff       	call   800038 <_main>
  80041f:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800422:	e8 8e 18 00 00       	call   801cb5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800427:	83 ec 0c             	sub    $0xc,%esp
  80042a:	68 fc 23 80 00       	push   $0x8023fc
  80042f:	e8 52 03 00 00       	call   800786 <cprintf>
  800434:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800437:	a1 20 30 80 00       	mov    0x803020,%eax
  80043c:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800442:	a1 20 30 80 00       	mov    0x803020,%eax
  800447:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80044d:	83 ec 04             	sub    $0x4,%esp
  800450:	52                   	push   %edx
  800451:	50                   	push   %eax
  800452:	68 24 24 80 00       	push   $0x802424
  800457:	e8 2a 03 00 00       	call   800786 <cprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80045f:	a1 20 30 80 00       	mov    0x803020,%eax
  800464:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80046a:	a1 20 30 80 00       	mov    0x803020,%eax
  80046f:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	52                   	push   %edx
  800479:	50                   	push   %eax
  80047a:	68 4c 24 80 00       	push   $0x80244c
  80047f:	e8 02 03 00 00       	call   800786 <cprintf>
  800484:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800487:	a1 20 30 80 00       	mov    0x803020,%eax
  80048c:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 8d 24 80 00       	push   $0x80248d
  80049b:	e8 e6 02 00 00       	call   800786 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004a3:	83 ec 0c             	sub    $0xc,%esp
  8004a6:	68 fc 23 80 00       	push   $0x8023fc
  8004ab:	e8 d6 02 00 00       	call   800786 <cprintf>
  8004b0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004b3:	e8 17 18 00 00       	call   801ccf <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004b8:	e8 19 00 00 00       	call   8004d6 <exit>
}
  8004bd:	90                   	nop
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8004c6:	83 ec 0c             	sub    $0xc,%esp
  8004c9:	6a 00                	push   $0x0
  8004cb:	e8 16 16 00 00       	call   801ae6 <sys_env_destroy>
  8004d0:	83 c4 10             	add    $0x10,%esp
}
  8004d3:	90                   	nop
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <exit>:

void
exit(void)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8004dc:	e8 6b 16 00 00       	call   801b4c <sys_env_exit>
}
  8004e1:	90                   	nop
  8004e2:	c9                   	leave  
  8004e3:	c3                   	ret    

008004e4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004e4:	55                   	push   %ebp
  8004e5:	89 e5                	mov    %esp,%ebp
  8004e7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ea:	8d 45 10             	lea    0x10(%ebp),%eax
  8004ed:	83 c0 04             	add    $0x4,%eax
  8004f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004f3:	a1 18 31 80 00       	mov    0x803118,%eax
  8004f8:	85 c0                	test   %eax,%eax
  8004fa:	74 16                	je     800512 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004fc:	a1 18 31 80 00       	mov    0x803118,%eax
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	50                   	push   %eax
  800505:	68 a4 24 80 00       	push   $0x8024a4
  80050a:	e8 77 02 00 00       	call   800786 <cprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800512:	a1 00 30 80 00       	mov    0x803000,%eax
  800517:	ff 75 0c             	pushl  0xc(%ebp)
  80051a:	ff 75 08             	pushl  0x8(%ebp)
  80051d:	50                   	push   %eax
  80051e:	68 a9 24 80 00       	push   $0x8024a9
  800523:	e8 5e 02 00 00       	call   800786 <cprintf>
  800528:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80052b:	8b 45 10             	mov    0x10(%ebp),%eax
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	ff 75 f4             	pushl  -0xc(%ebp)
  800534:	50                   	push   %eax
  800535:	e8 e1 01 00 00       	call   80071b <vcprintf>
  80053a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80053d:	83 ec 08             	sub    $0x8,%esp
  800540:	6a 00                	push   $0x0
  800542:	68 c5 24 80 00       	push   $0x8024c5
  800547:	e8 cf 01 00 00       	call   80071b <vcprintf>
  80054c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80054f:	e8 82 ff ff ff       	call   8004d6 <exit>

	// should not return here
	while (1) ;
  800554:	eb fe                	jmp    800554 <_panic+0x70>

00800556 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
  800559:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80055c:	a1 20 30 80 00       	mov    0x803020,%eax
  800561:	8b 50 74             	mov    0x74(%eax),%edx
  800564:	8b 45 0c             	mov    0xc(%ebp),%eax
  800567:	39 c2                	cmp    %eax,%edx
  800569:	74 14                	je     80057f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80056b:	83 ec 04             	sub    $0x4,%esp
  80056e:	68 c8 24 80 00       	push   $0x8024c8
  800573:	6a 26                	push   $0x26
  800575:	68 14 25 80 00       	push   $0x802514
  80057a:	e8 65 ff ff ff       	call   8004e4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80057f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800586:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80058d:	e9 b6 00 00 00       	jmp    800648 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800595:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059c:	8b 45 08             	mov    0x8(%ebp),%eax
  80059f:	01 d0                	add    %edx,%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	85 c0                	test   %eax,%eax
  8005a5:	75 08                	jne    8005af <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005a7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005aa:	e9 96 00 00 00       	jmp    800645 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8005af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005bd:	eb 5d                	jmp    80061c <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8005c4:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8005ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005cd:	c1 e2 04             	shl    $0x4,%edx
  8005d0:	01 d0                	add    %edx,%eax
  8005d2:	8a 40 04             	mov    0x4(%eax),%al
  8005d5:	84 c0                	test   %al,%al
  8005d7:	75 40                	jne    800619 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005de:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8005e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005e7:	c1 e2 04             	shl    $0x4,%edx
  8005ea:	01 d0                	add    %edx,%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005f9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800605:	8b 45 08             	mov    0x8(%ebp),%eax
  800608:	01 c8                	add    %ecx,%eax
  80060a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80060c:	39 c2                	cmp    %eax,%edx
  80060e:	75 09                	jne    800619 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800610:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800617:	eb 12                	jmp    80062b <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800619:	ff 45 e8             	incl   -0x18(%ebp)
  80061c:	a1 20 30 80 00       	mov    0x803020,%eax
  800621:	8b 50 74             	mov    0x74(%eax),%edx
  800624:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800627:	39 c2                	cmp    %eax,%edx
  800629:	77 94                	ja     8005bf <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80062b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80062f:	75 14                	jne    800645 <CheckWSWithoutLastIndex+0xef>
			panic(
  800631:	83 ec 04             	sub    $0x4,%esp
  800634:	68 20 25 80 00       	push   $0x802520
  800639:	6a 3a                	push   $0x3a
  80063b:	68 14 25 80 00       	push   $0x802514
  800640:	e8 9f fe ff ff       	call   8004e4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800645:	ff 45 f0             	incl   -0x10(%ebp)
  800648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80064e:	0f 8c 3e ff ff ff    	jl     800592 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800654:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80065b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800662:	eb 20                	jmp    800684 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800664:	a1 20 30 80 00       	mov    0x803020,%eax
  800669:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80066f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800672:	c1 e2 04             	shl    $0x4,%edx
  800675:	01 d0                	add    %edx,%eax
  800677:	8a 40 04             	mov    0x4(%eax),%al
  80067a:	3c 01                	cmp    $0x1,%al
  80067c:	75 03                	jne    800681 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80067e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800681:	ff 45 e0             	incl   -0x20(%ebp)
  800684:	a1 20 30 80 00       	mov    0x803020,%eax
  800689:	8b 50 74             	mov    0x74(%eax),%edx
  80068c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80068f:	39 c2                	cmp    %eax,%edx
  800691:	77 d1                	ja     800664 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800696:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800699:	74 14                	je     8006af <CheckWSWithoutLastIndex+0x159>
		panic(
  80069b:	83 ec 04             	sub    $0x4,%esp
  80069e:	68 74 25 80 00       	push   $0x802574
  8006a3:	6a 44                	push   $0x44
  8006a5:	68 14 25 80 00       	push   $0x802514
  8006aa:	e8 35 fe ff ff       	call   8004e4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006af:	90                   	nop
  8006b0:	c9                   	leave  
  8006b1:	c3                   	ret    

008006b2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006b2:	55                   	push   %ebp
  8006b3:	89 e5                	mov    %esp,%ebp
  8006b5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	8d 48 01             	lea    0x1(%eax),%ecx
  8006c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c3:	89 0a                	mov    %ecx,(%edx)
  8006c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8006c8:	88 d1                	mov    %dl,%cl
  8006ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006cd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006db:	75 2c                	jne    800709 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006dd:	a0 24 30 80 00       	mov    0x803024,%al
  8006e2:	0f b6 c0             	movzbl %al,%eax
  8006e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e8:	8b 12                	mov    (%edx),%edx
  8006ea:	89 d1                	mov    %edx,%ecx
  8006ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ef:	83 c2 08             	add    $0x8,%edx
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	50                   	push   %eax
  8006f6:	51                   	push   %ecx
  8006f7:	52                   	push   %edx
  8006f8:	e8 a7 13 00 00       	call   801aa4 <sys_cputs>
  8006fd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800700:	8b 45 0c             	mov    0xc(%ebp),%eax
  800703:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070c:	8b 40 04             	mov    0x4(%eax),%eax
  80070f:	8d 50 01             	lea    0x1(%eax),%edx
  800712:	8b 45 0c             	mov    0xc(%ebp),%eax
  800715:	89 50 04             	mov    %edx,0x4(%eax)
}
  800718:	90                   	nop
  800719:	c9                   	leave  
  80071a:	c3                   	ret    

0080071b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
  80071e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800724:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80072b:	00 00 00 
	b.cnt = 0;
  80072e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800735:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800738:	ff 75 0c             	pushl  0xc(%ebp)
  80073b:	ff 75 08             	pushl  0x8(%ebp)
  80073e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800744:	50                   	push   %eax
  800745:	68 b2 06 80 00       	push   $0x8006b2
  80074a:	e8 11 02 00 00       	call   800960 <vprintfmt>
  80074f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800752:	a0 24 30 80 00       	mov    0x803024,%al
  800757:	0f b6 c0             	movzbl %al,%eax
  80075a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800760:	83 ec 04             	sub    $0x4,%esp
  800763:	50                   	push   %eax
  800764:	52                   	push   %edx
  800765:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076b:	83 c0 08             	add    $0x8,%eax
  80076e:	50                   	push   %eax
  80076f:	e8 30 13 00 00       	call   801aa4 <sys_cputs>
  800774:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800777:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80077e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800784:	c9                   	leave  
  800785:	c3                   	ret    

00800786 <cprintf>:

int cprintf(const char *fmt, ...) {
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80078c:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800793:	8d 45 0c             	lea    0xc(%ebp),%eax
  800796:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a2:	50                   	push   %eax
  8007a3:	e8 73 ff ff ff       	call   80071b <vcprintf>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b1:	c9                   	leave  
  8007b2:	c3                   	ret    

008007b3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007b3:	55                   	push   %ebp
  8007b4:	89 e5                	mov    %esp,%ebp
  8007b6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007b9:	e8 f7 14 00 00       	call   801cb5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007be:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	83 ec 08             	sub    $0x8,%esp
  8007ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cd:	50                   	push   %eax
  8007ce:	e8 48 ff ff ff       	call   80071b <vcprintf>
  8007d3:	83 c4 10             	add    $0x10,%esp
  8007d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007d9:	e8 f1 14 00 00       	call   801ccf <sys_enable_interrupt>
	return cnt;
  8007de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e1:	c9                   	leave  
  8007e2:	c3                   	ret    

008007e3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e3:	55                   	push   %ebp
  8007e4:	89 e5                	mov    %esp,%ebp
  8007e6:	53                   	push   %ebx
  8007e7:	83 ec 14             	sub    $0x14,%esp
  8007ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f6:	8b 45 18             	mov    0x18(%ebp),%eax
  8007f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800801:	77 55                	ja     800858 <printnum+0x75>
  800803:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800806:	72 05                	jb     80080d <printnum+0x2a>
  800808:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80080b:	77 4b                	ja     800858 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80080d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800810:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800813:	8b 45 18             	mov    0x18(%ebp),%eax
  800816:	ba 00 00 00 00       	mov    $0x0,%edx
  80081b:	52                   	push   %edx
  80081c:	50                   	push   %eax
  80081d:	ff 75 f4             	pushl  -0xc(%ebp)
  800820:	ff 75 f0             	pushl  -0x10(%ebp)
  800823:	e8 b0 18 00 00       	call   8020d8 <__udivdi3>
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	ff 75 20             	pushl  0x20(%ebp)
  800831:	53                   	push   %ebx
  800832:	ff 75 18             	pushl  0x18(%ebp)
  800835:	52                   	push   %edx
  800836:	50                   	push   %eax
  800837:	ff 75 0c             	pushl  0xc(%ebp)
  80083a:	ff 75 08             	pushl  0x8(%ebp)
  80083d:	e8 a1 ff ff ff       	call   8007e3 <printnum>
  800842:	83 c4 20             	add    $0x20,%esp
  800845:	eb 1a                	jmp    800861 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	ff 75 0c             	pushl  0xc(%ebp)
  80084d:	ff 75 20             	pushl  0x20(%ebp)
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	ff d0                	call   *%eax
  800855:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800858:	ff 4d 1c             	decl   0x1c(%ebp)
  80085b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80085f:	7f e6                	jg     800847 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800861:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800864:	bb 00 00 00 00       	mov    $0x0,%ebx
  800869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80086f:	53                   	push   %ebx
  800870:	51                   	push   %ecx
  800871:	52                   	push   %edx
  800872:	50                   	push   %eax
  800873:	e8 70 19 00 00       	call   8021e8 <__umoddi3>
  800878:	83 c4 10             	add    $0x10,%esp
  80087b:	05 d4 27 80 00       	add    $0x8027d4,%eax
  800880:	8a 00                	mov    (%eax),%al
  800882:	0f be c0             	movsbl %al,%eax
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	ff 75 0c             	pushl  0xc(%ebp)
  80088b:	50                   	push   %eax
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	ff d0                	call   *%eax
  800891:	83 c4 10             	add    $0x10,%esp
}
  800894:	90                   	nop
  800895:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800898:	c9                   	leave  
  800899:	c3                   	ret    

0080089a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80089d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a1:	7e 1c                	jle    8008bf <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	8b 00                	mov    (%eax),%eax
  8008a8:	8d 50 08             	lea    0x8(%eax),%edx
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	89 10                	mov    %edx,(%eax)
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	8b 00                	mov    (%eax),%eax
  8008b5:	83 e8 08             	sub    $0x8,%eax
  8008b8:	8b 50 04             	mov    0x4(%eax),%edx
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	eb 40                	jmp    8008ff <getuint+0x65>
	else if (lflag)
  8008bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c3:	74 1e                	je     8008e3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	8d 50 04             	lea    0x4(%eax),%edx
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	89 10                	mov    %edx,(%eax)
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	83 e8 04             	sub    $0x4,%eax
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e1:	eb 1c                	jmp    8008ff <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	8d 50 04             	lea    0x4(%eax),%edx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	89 10                	mov    %edx,(%eax)
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	83 e8 04             	sub    $0x4,%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    

00800901 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800904:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800908:	7e 1c                	jle    800926 <getint+0x25>
		return va_arg(*ap, long long);
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	8d 50 08             	lea    0x8(%eax),%edx
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	89 10                	mov    %edx,(%eax)
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	83 e8 08             	sub    $0x8,%eax
  80091f:	8b 50 04             	mov    0x4(%eax),%edx
  800922:	8b 00                	mov    (%eax),%eax
  800924:	eb 38                	jmp    80095e <getint+0x5d>
	else if (lflag)
  800926:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092a:	74 1a                	je     800946 <getint+0x45>
		return va_arg(*ap, long);
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	8d 50 04             	lea    0x4(%eax),%edx
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	89 10                	mov    %edx,(%eax)
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	83 e8 04             	sub    $0x4,%eax
  800941:	8b 00                	mov    (%eax),%eax
  800943:	99                   	cltd   
  800944:	eb 18                	jmp    80095e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	8d 50 04             	lea    0x4(%eax),%edx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	89 10                	mov    %edx,(%eax)
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	83 e8 04             	sub    $0x4,%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	99                   	cltd   
}
  80095e:	5d                   	pop    %ebp
  80095f:	c3                   	ret    

00800960 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	56                   	push   %esi
  800964:	53                   	push   %ebx
  800965:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800968:	eb 17                	jmp    800981 <vprintfmt+0x21>
			if (ch == '\0')
  80096a:	85 db                	test   %ebx,%ebx
  80096c:	0f 84 af 03 00 00    	je     800d21 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	53                   	push   %ebx
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	ff d0                	call   *%eax
  80097e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800981:	8b 45 10             	mov    0x10(%ebp),%eax
  800984:	8d 50 01             	lea    0x1(%eax),%edx
  800987:	89 55 10             	mov    %edx,0x10(%ebp)
  80098a:	8a 00                	mov    (%eax),%al
  80098c:	0f b6 d8             	movzbl %al,%ebx
  80098f:	83 fb 25             	cmp    $0x25,%ebx
  800992:	75 d6                	jne    80096a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800994:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800998:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80099f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009a6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009ad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b7:	8d 50 01             	lea    0x1(%eax),%edx
  8009ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8009bd:	8a 00                	mov    (%eax),%al
  8009bf:	0f b6 d8             	movzbl %al,%ebx
  8009c2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c5:	83 f8 55             	cmp    $0x55,%eax
  8009c8:	0f 87 2b 03 00 00    	ja     800cf9 <vprintfmt+0x399>
  8009ce:	8b 04 85 f8 27 80 00 	mov    0x8027f8(,%eax,4),%eax
  8009d5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009d7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009db:	eb d7                	jmp    8009b4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009dd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e1:	eb d1                	jmp    8009b4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009ed:	89 d0                	mov    %edx,%eax
  8009ef:	c1 e0 02             	shl    $0x2,%eax
  8009f2:	01 d0                	add    %edx,%eax
  8009f4:	01 c0                	add    %eax,%eax
  8009f6:	01 d8                	add    %ebx,%eax
  8009f8:	83 e8 30             	sub    $0x30,%eax
  8009fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800a01:	8a 00                	mov    (%eax),%al
  800a03:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a06:	83 fb 2f             	cmp    $0x2f,%ebx
  800a09:	7e 3e                	jle    800a49 <vprintfmt+0xe9>
  800a0b:	83 fb 39             	cmp    $0x39,%ebx
  800a0e:	7f 39                	jg     800a49 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a10:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a13:	eb d5                	jmp    8009ea <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a15:	8b 45 14             	mov    0x14(%ebp),%eax
  800a18:	83 c0 04             	add    $0x4,%eax
  800a1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a21:	83 e8 04             	sub    $0x4,%eax
  800a24:	8b 00                	mov    (%eax),%eax
  800a26:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a29:	eb 1f                	jmp    800a4a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2f:	79 83                	jns    8009b4 <vprintfmt+0x54>
				width = 0;
  800a31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a38:	e9 77 ff ff ff       	jmp    8009b4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a3d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a44:	e9 6b ff ff ff       	jmp    8009b4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a49:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4e:	0f 89 60 ff ff ff    	jns    8009b4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a5a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a61:	e9 4e ff ff ff       	jmp    8009b4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a66:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a69:	e9 46 ff ff ff       	jmp    8009b4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a71:	83 c0 04             	add    $0x4,%eax
  800a74:	89 45 14             	mov    %eax,0x14(%ebp)
  800a77:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7a:	83 e8 04             	sub    $0x4,%eax
  800a7d:	8b 00                	mov    (%eax),%eax
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	50                   	push   %eax
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	ff d0                	call   *%eax
  800a8b:	83 c4 10             	add    $0x10,%esp
			break;
  800a8e:	e9 89 02 00 00       	jmp    800d1c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a93:	8b 45 14             	mov    0x14(%ebp),%eax
  800a96:	83 c0 04             	add    $0x4,%eax
  800a99:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9f:	83 e8 04             	sub    $0x4,%eax
  800aa2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa4:	85 db                	test   %ebx,%ebx
  800aa6:	79 02                	jns    800aaa <vprintfmt+0x14a>
				err = -err;
  800aa8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aaa:	83 fb 64             	cmp    $0x64,%ebx
  800aad:	7f 0b                	jg     800aba <vprintfmt+0x15a>
  800aaf:	8b 34 9d 40 26 80 00 	mov    0x802640(,%ebx,4),%esi
  800ab6:	85 f6                	test   %esi,%esi
  800ab8:	75 19                	jne    800ad3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aba:	53                   	push   %ebx
  800abb:	68 e5 27 80 00       	push   $0x8027e5
  800ac0:	ff 75 0c             	pushl  0xc(%ebp)
  800ac3:	ff 75 08             	pushl  0x8(%ebp)
  800ac6:	e8 5e 02 00 00       	call   800d29 <printfmt>
  800acb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ace:	e9 49 02 00 00       	jmp    800d1c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad3:	56                   	push   %esi
  800ad4:	68 ee 27 80 00       	push   $0x8027ee
  800ad9:	ff 75 0c             	pushl  0xc(%ebp)
  800adc:	ff 75 08             	pushl  0x8(%ebp)
  800adf:	e8 45 02 00 00       	call   800d29 <printfmt>
  800ae4:	83 c4 10             	add    $0x10,%esp
			break;
  800ae7:	e9 30 02 00 00       	jmp    800d1c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 c0 04             	add    $0x4,%eax
  800af2:	89 45 14             	mov    %eax,0x14(%ebp)
  800af5:	8b 45 14             	mov    0x14(%ebp),%eax
  800af8:	83 e8 04             	sub    $0x4,%eax
  800afb:	8b 30                	mov    (%eax),%esi
  800afd:	85 f6                	test   %esi,%esi
  800aff:	75 05                	jne    800b06 <vprintfmt+0x1a6>
				p = "(null)";
  800b01:	be f1 27 80 00       	mov    $0x8027f1,%esi
			if (width > 0 && padc != '-')
  800b06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0a:	7e 6d                	jle    800b79 <vprintfmt+0x219>
  800b0c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b10:	74 67                	je     800b79 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b15:	83 ec 08             	sub    $0x8,%esp
  800b18:	50                   	push   %eax
  800b19:	56                   	push   %esi
  800b1a:	e8 0c 03 00 00       	call   800e2b <strnlen>
  800b1f:	83 c4 10             	add    $0x10,%esp
  800b22:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b25:	eb 16                	jmp    800b3d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b27:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	50                   	push   %eax
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b41:	7f e4                	jg     800b27 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b43:	eb 34                	jmp    800b79 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b45:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b49:	74 1c                	je     800b67 <vprintfmt+0x207>
  800b4b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b4e:	7e 05                	jle    800b55 <vprintfmt+0x1f5>
  800b50:	83 fb 7e             	cmp    $0x7e,%ebx
  800b53:	7e 12                	jle    800b67 <vprintfmt+0x207>
					putch('?', putdat);
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	6a 3f                	push   $0x3f
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	eb 0f                	jmp    800b76 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b67:	83 ec 08             	sub    $0x8,%esp
  800b6a:	ff 75 0c             	pushl  0xc(%ebp)
  800b6d:	53                   	push   %ebx
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	ff d0                	call   *%eax
  800b73:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b76:	ff 4d e4             	decl   -0x1c(%ebp)
  800b79:	89 f0                	mov    %esi,%eax
  800b7b:	8d 70 01             	lea    0x1(%eax),%esi
  800b7e:	8a 00                	mov    (%eax),%al
  800b80:	0f be d8             	movsbl %al,%ebx
  800b83:	85 db                	test   %ebx,%ebx
  800b85:	74 24                	je     800bab <vprintfmt+0x24b>
  800b87:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8b:	78 b8                	js     800b45 <vprintfmt+0x1e5>
  800b8d:	ff 4d e0             	decl   -0x20(%ebp)
  800b90:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b94:	79 af                	jns    800b45 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b96:	eb 13                	jmp    800bab <vprintfmt+0x24b>
				putch(' ', putdat);
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	ff 75 0c             	pushl  0xc(%ebp)
  800b9e:	6a 20                	push   $0x20
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	ff d0                	call   *%eax
  800ba5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800baf:	7f e7                	jg     800b98 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb1:	e9 66 01 00 00       	jmp    800d1c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bb6:	83 ec 08             	sub    $0x8,%esp
  800bb9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bbc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bbf:	50                   	push   %eax
  800bc0:	e8 3c fd ff ff       	call   800901 <getint>
  800bc5:	83 c4 10             	add    $0x10,%esp
  800bc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd4:	85 d2                	test   %edx,%edx
  800bd6:	79 23                	jns    800bfb <vprintfmt+0x29b>
				putch('-', putdat);
  800bd8:	83 ec 08             	sub    $0x8,%esp
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	6a 2d                	push   $0x2d
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	ff d0                	call   *%eax
  800be5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800beb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bee:	f7 d8                	neg    %eax
  800bf0:	83 d2 00             	adc    $0x0,%edx
  800bf3:	f7 da                	neg    %edx
  800bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bfb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c02:	e9 bc 00 00 00       	jmp    800cc3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c07:	83 ec 08             	sub    $0x8,%esp
  800c0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c10:	50                   	push   %eax
  800c11:	e8 84 fc ff ff       	call   80089a <getuint>
  800c16:	83 c4 10             	add    $0x10,%esp
  800c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c1f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c26:	e9 98 00 00 00       	jmp    800cc3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c2b:	83 ec 08             	sub    $0x8,%esp
  800c2e:	ff 75 0c             	pushl  0xc(%ebp)
  800c31:	6a 58                	push   $0x58
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	ff d0                	call   *%eax
  800c38:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	6a 58                	push   $0x58
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	ff d0                	call   *%eax
  800c48:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	6a 58                	push   $0x58
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	ff d0                	call   *%eax
  800c58:	83 c4 10             	add    $0x10,%esp
			break;
  800c5b:	e9 bc 00 00 00       	jmp    800d1c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c60:	83 ec 08             	sub    $0x8,%esp
  800c63:	ff 75 0c             	pushl  0xc(%ebp)
  800c66:	6a 30                	push   $0x30
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	ff d0                	call   *%eax
  800c6d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c70:	83 ec 08             	sub    $0x8,%esp
  800c73:	ff 75 0c             	pushl  0xc(%ebp)
  800c76:	6a 78                	push   $0x78
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	ff d0                	call   *%eax
  800c7d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c80:	8b 45 14             	mov    0x14(%ebp),%eax
  800c83:	83 c0 04             	add    $0x4,%eax
  800c86:	89 45 14             	mov    %eax,0x14(%ebp)
  800c89:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8c:	83 e8 04             	sub    $0x4,%eax
  800c8f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c9b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca2:	eb 1f                	jmp    800cc3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca4:	83 ec 08             	sub    $0x8,%esp
  800ca7:	ff 75 e8             	pushl  -0x18(%ebp)
  800caa:	8d 45 14             	lea    0x14(%ebp),%eax
  800cad:	50                   	push   %eax
  800cae:	e8 e7 fb ff ff       	call   80089a <getuint>
  800cb3:	83 c4 10             	add    $0x10,%esp
  800cb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cbc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cca:	83 ec 04             	sub    $0x4,%esp
  800ccd:	52                   	push   %edx
  800cce:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd1:	50                   	push   %eax
  800cd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd5:	ff 75 f0             	pushl  -0x10(%ebp)
  800cd8:	ff 75 0c             	pushl  0xc(%ebp)
  800cdb:	ff 75 08             	pushl  0x8(%ebp)
  800cde:	e8 00 fb ff ff       	call   8007e3 <printnum>
  800ce3:	83 c4 20             	add    $0x20,%esp
			break;
  800ce6:	eb 34                	jmp    800d1c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ce8:	83 ec 08             	sub    $0x8,%esp
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	53                   	push   %ebx
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	ff d0                	call   *%eax
  800cf4:	83 c4 10             	add    $0x10,%esp
			break;
  800cf7:	eb 23                	jmp    800d1c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cf9:	83 ec 08             	sub    $0x8,%esp
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	6a 25                	push   $0x25
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	ff d0                	call   *%eax
  800d06:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d09:	ff 4d 10             	decl   0x10(%ebp)
  800d0c:	eb 03                	jmp    800d11 <vprintfmt+0x3b1>
  800d0e:	ff 4d 10             	decl   0x10(%ebp)
  800d11:	8b 45 10             	mov    0x10(%ebp),%eax
  800d14:	48                   	dec    %eax
  800d15:	8a 00                	mov    (%eax),%al
  800d17:	3c 25                	cmp    $0x25,%al
  800d19:	75 f3                	jne    800d0e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d1b:	90                   	nop
		}
	}
  800d1c:	e9 47 fc ff ff       	jmp    800968 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d21:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d2f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d32:	83 c0 04             	add    $0x4,%eax
  800d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d38:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3e:	50                   	push   %eax
  800d3f:	ff 75 0c             	pushl  0xc(%ebp)
  800d42:	ff 75 08             	pushl  0x8(%ebp)
  800d45:	e8 16 fc ff ff       	call   800960 <vprintfmt>
  800d4a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d4d:	90                   	nop
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d56:	8b 40 08             	mov    0x8(%eax),%eax
  800d59:	8d 50 01             	lea    0x1(%eax),%edx
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	8b 10                	mov    (%eax),%edx
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	8b 40 04             	mov    0x4(%eax),%eax
  800d6d:	39 c2                	cmp    %eax,%edx
  800d6f:	73 12                	jae    800d83 <sprintputch+0x33>
		*b->buf++ = ch;
  800d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d74:	8b 00                	mov    (%eax),%eax
  800d76:	8d 48 01             	lea    0x1(%eax),%ecx
  800d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7c:	89 0a                	mov    %ecx,(%edx)
  800d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d81:	88 10                	mov    %dl,(%eax)
}
  800d83:	90                   	nop
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	01 d0                	add    %edx,%eax
  800d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800da7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dab:	74 06                	je     800db3 <vsnprintf+0x2d>
  800dad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db1:	7f 07                	jg     800dba <vsnprintf+0x34>
		return -E_INVAL;
  800db3:	b8 03 00 00 00       	mov    $0x3,%eax
  800db8:	eb 20                	jmp    800dda <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dba:	ff 75 14             	pushl  0x14(%ebp)
  800dbd:	ff 75 10             	pushl  0x10(%ebp)
  800dc0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc3:	50                   	push   %eax
  800dc4:	68 50 0d 80 00       	push   $0x800d50
  800dc9:	e8 92 fb ff ff       	call   800960 <vprintfmt>
  800dce:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de2:	8d 45 10             	lea    0x10(%ebp),%eax
  800de5:	83 c0 04             	add    $0x4,%eax
  800de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800deb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dee:	ff 75 f4             	pushl  -0xc(%ebp)
  800df1:	50                   	push   %eax
  800df2:	ff 75 0c             	pushl  0xc(%ebp)
  800df5:	ff 75 08             	pushl  0x8(%ebp)
  800df8:	e8 89 ff ff ff       	call   800d86 <vsnprintf>
  800dfd:	83 c4 10             	add    $0x10,%esp
  800e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e15:	eb 06                	jmp    800e1d <strlen+0x15>
		n++;
  800e17:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1a:	ff 45 08             	incl   0x8(%ebp)
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	84 c0                	test   %al,%al
  800e24:	75 f1                	jne    800e17 <strlen+0xf>
		n++;
	return n;
  800e26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e29:	c9                   	leave  
  800e2a:	c3                   	ret    

00800e2b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e38:	eb 09                	jmp    800e43 <strnlen+0x18>
		n++;
  800e3a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e3d:	ff 45 08             	incl   0x8(%ebp)
  800e40:	ff 4d 0c             	decl   0xc(%ebp)
  800e43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e47:	74 09                	je     800e52 <strnlen+0x27>
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	84 c0                	test   %al,%al
  800e50:	75 e8                	jne    800e3a <strnlen+0xf>
		n++;
	return n;
  800e52:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e55:	c9                   	leave  
  800e56:	c3                   	ret    

00800e57 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e63:	90                   	nop
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8d 50 01             	lea    0x1(%eax),%edx
  800e6a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e70:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e73:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e76:	8a 12                	mov    (%edx),%dl
  800e78:	88 10                	mov    %dl,(%eax)
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	84 c0                	test   %al,%al
  800e7e:	75 e4                	jne    800e64 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e83:	c9                   	leave  
  800e84:	c3                   	ret    

00800e85 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e98:	eb 1f                	jmp    800eb9 <strncpy+0x34>
		*dst++ = *src;
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea6:	8a 12                	mov    (%edx),%dl
  800ea8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	84 c0                	test   %al,%al
  800eb1:	74 03                	je     800eb6 <strncpy+0x31>
			src++;
  800eb3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eb6:	ff 45 fc             	incl   -0x4(%ebp)
  800eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ebf:	72 d9                	jb     800e9a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec4:	c9                   	leave  
  800ec5:	c3                   	ret    

00800ec6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed6:	74 30                	je     800f08 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ed8:	eb 16                	jmp    800ef0 <strlcpy+0x2a>
			*dst++ = *src++;
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8d 50 01             	lea    0x1(%eax),%edx
  800ee0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eec:	8a 12                	mov    (%edx),%dl
  800eee:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef0:	ff 4d 10             	decl   0x10(%ebp)
  800ef3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef7:	74 09                	je     800f02 <strlcpy+0x3c>
  800ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	84 c0                	test   %al,%al
  800f00:	75 d8                	jne    800eda <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f08:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0e:	29 c2                	sub    %eax,%edx
  800f10:	89 d0                	mov    %edx,%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f17:	eb 06                	jmp    800f1f <strcmp+0xb>
		p++, q++;
  800f19:	ff 45 08             	incl   0x8(%ebp)
  800f1c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	84 c0                	test   %al,%al
  800f26:	74 0e                	je     800f36 <strcmp+0x22>
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 10                	mov    (%eax),%dl
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	38 c2                	cmp    %al,%dl
  800f34:	74 e3                	je     800f19 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	0f b6 d0             	movzbl %al,%edx
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	0f b6 c0             	movzbl %al,%eax
  800f46:	29 c2                	sub    %eax,%edx
  800f48:	89 d0                	mov    %edx,%eax
}
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    

00800f4c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f4f:	eb 09                	jmp    800f5a <strncmp+0xe>
		n--, p++, q++;
  800f51:	ff 4d 10             	decl   0x10(%ebp)
  800f54:	ff 45 08             	incl   0x8(%ebp)
  800f57:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5e:	74 17                	je     800f77 <strncmp+0x2b>
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	84 c0                	test   %al,%al
  800f67:	74 0e                	je     800f77 <strncmp+0x2b>
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	8a 10                	mov    (%eax),%dl
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	38 c2                	cmp    %al,%dl
  800f75:	74 da                	je     800f51 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7b:	75 07                	jne    800f84 <strncmp+0x38>
		return 0;
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f82:	eb 14                	jmp    800f98 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	0f b6 d0             	movzbl %al,%edx
  800f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	0f b6 c0             	movzbl %al,%eax
  800f94:	29 c2                	sub    %eax,%edx
  800f96:	89 d0                	mov    %edx,%eax
}
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    

00800f9a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 04             	sub    $0x4,%esp
  800fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fa6:	eb 12                	jmp    800fba <strchr+0x20>
		if (*s == c)
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb0:	75 05                	jne    800fb7 <strchr+0x1d>
			return (char *) s;
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	eb 11                	jmp    800fc8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fb7:	ff 45 08             	incl   0x8(%ebp)
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	84 c0                	test   %al,%al
  800fc1:	75 e5                	jne    800fa8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc8:	c9                   	leave  
  800fc9:	c3                   	ret    

00800fca <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	83 ec 04             	sub    $0x4,%esp
  800fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd6:	eb 0d                	jmp    800fe5 <strfind+0x1b>
		if (*s == c)
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe0:	74 0e                	je     800ff0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe2:	ff 45 08             	incl   0x8(%ebp)
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	84 c0                	test   %al,%al
  800fec:	75 ea                	jne    800fd8 <strfind+0xe>
  800fee:	eb 01                	jmp    800ff1 <strfind+0x27>
		if (*s == c)
			break;
  800ff0:	90                   	nop
	return (char *) s;
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801002:	8b 45 10             	mov    0x10(%ebp),%eax
  801005:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801008:	eb 0e                	jmp    801018 <memset+0x22>
		*p++ = c;
  80100a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100d:	8d 50 01             	lea    0x1(%eax),%edx
  801010:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801013:	8b 55 0c             	mov    0xc(%ebp),%edx
  801016:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801018:	ff 4d f8             	decl   -0x8(%ebp)
  80101b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80101f:	79 e9                	jns    80100a <memset+0x14>
		*p++ = c;

	return v;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801038:	eb 16                	jmp    801050 <memcpy+0x2a>
		*d++ = *s++;
  80103a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103d:	8d 50 01             	lea    0x1(%eax),%edx
  801040:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801043:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801046:	8d 4a 01             	lea    0x1(%edx),%ecx
  801049:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80104c:	8a 12                	mov    (%edx),%dl
  80104e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801050:	8b 45 10             	mov    0x10(%ebp),%eax
  801053:	8d 50 ff             	lea    -0x1(%eax),%edx
  801056:	89 55 10             	mov    %edx,0x10(%ebp)
  801059:	85 c0                	test   %eax,%eax
  80105b:	75 dd                	jne    80103a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801060:	c9                   	leave  
  801061:	c3                   	ret    

00801062 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801074:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801077:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107a:	73 50                	jae    8010cc <memmove+0x6a>
  80107c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80107f:	8b 45 10             	mov    0x10(%ebp),%eax
  801082:	01 d0                	add    %edx,%eax
  801084:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801087:	76 43                	jbe    8010cc <memmove+0x6a>
		s += n;
  801089:	8b 45 10             	mov    0x10(%ebp),%eax
  80108c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80108f:	8b 45 10             	mov    0x10(%ebp),%eax
  801092:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801095:	eb 10                	jmp    8010a7 <memmove+0x45>
			*--d = *--s;
  801097:	ff 4d f8             	decl   -0x8(%ebp)
  80109a:	ff 4d fc             	decl   -0x4(%ebp)
  80109d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a0:	8a 10                	mov    (%eax),%dl
  8010a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010aa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ad:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b0:	85 c0                	test   %eax,%eax
  8010b2:	75 e3                	jne    801097 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b4:	eb 23                	jmp    8010d9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b9:	8d 50 01             	lea    0x1(%eax),%edx
  8010bc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010c8:	8a 12                	mov    (%edx),%dl
  8010ca:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d5:	85 c0                	test   %eax,%eax
  8010d7:	75 dd                	jne    8010b6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

008010de <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ed:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010f0:	eb 2a                	jmp    80111c <memcmp+0x3e>
		if (*s1 != *s2)
  8010f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f5:	8a 10                	mov    (%eax),%dl
  8010f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	38 c2                	cmp    %al,%dl
  8010fe:	74 16                	je     801116 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801100:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	0f b6 d0             	movzbl %al,%edx
  801108:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	0f b6 c0             	movzbl %al,%eax
  801110:	29 c2                	sub    %eax,%edx
  801112:	89 d0                	mov    %edx,%eax
  801114:	eb 18                	jmp    80112e <memcmp+0x50>
		s1++, s2++;
  801116:	ff 45 fc             	incl   -0x4(%ebp)
  801119:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80111c:	8b 45 10             	mov    0x10(%ebp),%eax
  80111f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801122:	89 55 10             	mov    %edx,0x10(%ebp)
  801125:	85 c0                	test   %eax,%eax
  801127:	75 c9                	jne    8010f2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801129:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801136:	8b 55 08             	mov    0x8(%ebp),%edx
  801139:	8b 45 10             	mov    0x10(%ebp),%eax
  80113c:	01 d0                	add    %edx,%eax
  80113e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801141:	eb 15                	jmp    801158 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	0f b6 d0             	movzbl %al,%edx
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	0f b6 c0             	movzbl %al,%eax
  801151:	39 c2                	cmp    %eax,%edx
  801153:	74 0d                	je     801162 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801155:	ff 45 08             	incl   0x8(%ebp)
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80115e:	72 e3                	jb     801143 <memfind+0x13>
  801160:	eb 01                	jmp    801163 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801162:	90                   	nop
	return (void *) s;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801166:	c9                   	leave  
  801167:	c3                   	ret    

00801168 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80116e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801175:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80117c:	eb 03                	jmp    801181 <strtol+0x19>
		s++;
  80117e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	3c 20                	cmp    $0x20,%al
  801188:	74 f4                	je     80117e <strtol+0x16>
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 09                	cmp    $0x9,%al
  801191:	74 eb                	je     80117e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	3c 2b                	cmp    $0x2b,%al
  80119a:	75 05                	jne    8011a1 <strtol+0x39>
		s++;
  80119c:	ff 45 08             	incl   0x8(%ebp)
  80119f:	eb 13                	jmp    8011b4 <strtol+0x4c>
	else if (*s == '-')
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3c 2d                	cmp    $0x2d,%al
  8011a8:	75 0a                	jne    8011b4 <strtol+0x4c>
		s++, neg = 1;
  8011aa:	ff 45 08             	incl   0x8(%ebp)
  8011ad:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b8:	74 06                	je     8011c0 <strtol+0x58>
  8011ba:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011be:	75 20                	jne    8011e0 <strtol+0x78>
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	3c 30                	cmp    $0x30,%al
  8011c7:	75 17                	jne    8011e0 <strtol+0x78>
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	40                   	inc    %eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	3c 78                	cmp    $0x78,%al
  8011d1:	75 0d                	jne    8011e0 <strtol+0x78>
		s += 2, base = 16;
  8011d3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011d7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011de:	eb 28                	jmp    801208 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e4:	75 15                	jne    8011fb <strtol+0x93>
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3c 30                	cmp    $0x30,%al
  8011ed:	75 0c                	jne    8011fb <strtol+0x93>
		s++, base = 8;
  8011ef:	ff 45 08             	incl   0x8(%ebp)
  8011f2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011f9:	eb 0d                	jmp    801208 <strtol+0xa0>
	else if (base == 0)
  8011fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ff:	75 07                	jne    801208 <strtol+0xa0>
		base = 10;
  801201:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 2f                	cmp    $0x2f,%al
  80120f:	7e 19                	jle    80122a <strtol+0xc2>
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	3c 39                	cmp    $0x39,%al
  801218:	7f 10                	jg     80122a <strtol+0xc2>
			dig = *s - '0';
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	0f be c0             	movsbl %al,%eax
  801222:	83 e8 30             	sub    $0x30,%eax
  801225:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801228:	eb 42                	jmp    80126c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 60                	cmp    $0x60,%al
  801231:	7e 19                	jle    80124c <strtol+0xe4>
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	3c 7a                	cmp    $0x7a,%al
  80123a:	7f 10                	jg     80124c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8a 00                	mov    (%eax),%al
  801241:	0f be c0             	movsbl %al,%eax
  801244:	83 e8 57             	sub    $0x57,%eax
  801247:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80124a:	eb 20                	jmp    80126c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	3c 40                	cmp    $0x40,%al
  801253:	7e 39                	jle    80128e <strtol+0x126>
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	3c 5a                	cmp    $0x5a,%al
  80125c:	7f 30                	jg     80128e <strtol+0x126>
			dig = *s - 'A' + 10;
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	0f be c0             	movsbl %al,%eax
  801266:	83 e8 37             	sub    $0x37,%eax
  801269:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80126c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801272:	7d 19                	jge    80128d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801274:	ff 45 08             	incl   0x8(%ebp)
  801277:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80127e:	89 c2                	mov    %eax,%edx
  801280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801283:	01 d0                	add    %edx,%eax
  801285:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801288:	e9 7b ff ff ff       	jmp    801208 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80128d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80128e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801292:	74 08                	je     80129c <strtol+0x134>
		*endptr = (char *) s;
  801294:	8b 45 0c             	mov    0xc(%ebp),%eax
  801297:	8b 55 08             	mov    0x8(%ebp),%edx
  80129a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80129c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a0:	74 07                	je     8012a9 <strtol+0x141>
  8012a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a5:	f7 d8                	neg    %eax
  8012a7:	eb 03                	jmp    8012ac <strtol+0x144>
  8012a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <ltostr>:

void
ltostr(long value, char *str)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012c6:	79 13                	jns    8012db <ltostr+0x2d>
	{
		neg = 1;
  8012c8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012d5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012d8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012e3:	99                   	cltd   
  8012e4:	f7 f9                	idiv   %ecx
  8012e6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ec:	8d 50 01             	lea    0x1(%eax),%edx
  8012ef:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012f2:	89 c2                	mov    %eax,%edx
  8012f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f7:	01 d0                	add    %edx,%eax
  8012f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012fc:	83 c2 30             	add    $0x30,%edx
  8012ff:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801301:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801304:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801309:	f7 e9                	imul   %ecx
  80130b:	c1 fa 02             	sar    $0x2,%edx
  80130e:	89 c8                	mov    %ecx,%eax
  801310:	c1 f8 1f             	sar    $0x1f,%eax
  801313:	29 c2                	sub    %eax,%edx
  801315:	89 d0                	mov    %edx,%eax
  801317:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80131a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80131d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801322:	f7 e9                	imul   %ecx
  801324:	c1 fa 02             	sar    $0x2,%edx
  801327:	89 c8                	mov    %ecx,%eax
  801329:	c1 f8 1f             	sar    $0x1f,%eax
  80132c:	29 c2                	sub    %eax,%edx
  80132e:	89 d0                	mov    %edx,%eax
  801330:	c1 e0 02             	shl    $0x2,%eax
  801333:	01 d0                	add    %edx,%eax
  801335:	01 c0                	add    %eax,%eax
  801337:	29 c1                	sub    %eax,%ecx
  801339:	89 ca                	mov    %ecx,%edx
  80133b:	85 d2                	test   %edx,%edx
  80133d:	75 9c                	jne    8012db <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80133f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801346:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801349:	48                   	dec    %eax
  80134a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80134d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801351:	74 3d                	je     801390 <ltostr+0xe2>
		start = 1 ;
  801353:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80135a:	eb 34                	jmp    801390 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80135c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80135f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801362:	01 d0                	add    %edx,%eax
  801364:	8a 00                	mov    (%eax),%al
  801366:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801369:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 c2                	add    %eax,%edx
  801371:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801374:	8b 45 0c             	mov    0xc(%ebp),%eax
  801377:	01 c8                	add    %ecx,%eax
  801379:	8a 00                	mov    (%eax),%al
  80137b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80137d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	01 c2                	add    %eax,%edx
  801385:	8a 45 eb             	mov    -0x15(%ebp),%al
  801388:	88 02                	mov    %al,(%edx)
		start++ ;
  80138a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80138d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801393:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801396:	7c c4                	jl     80135c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801398:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80139b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139e:	01 d0                	add    %edx,%eax
  8013a0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013a3:	90                   	nop
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013ac:	ff 75 08             	pushl  0x8(%ebp)
  8013af:	e8 54 fa ff ff       	call   800e08 <strlen>
  8013b4:	83 c4 04             	add    $0x4,%esp
  8013b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013ba:	ff 75 0c             	pushl  0xc(%ebp)
  8013bd:	e8 46 fa ff ff       	call   800e08 <strlen>
  8013c2:	83 c4 04             	add    $0x4,%esp
  8013c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013d6:	eb 17                	jmp    8013ef <strcconcat+0x49>
		final[s] = str1[s] ;
  8013d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013db:	8b 45 10             	mov    0x10(%ebp),%eax
  8013de:	01 c2                	add    %eax,%edx
  8013e0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	01 c8                	add    %ecx,%eax
  8013e8:	8a 00                	mov    (%eax),%al
  8013ea:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013ec:	ff 45 fc             	incl   -0x4(%ebp)
  8013ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013f5:	7c e1                	jl     8013d8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013f7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801405:	eb 1f                	jmp    801426 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140a:	8d 50 01             	lea    0x1(%eax),%edx
  80140d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801410:	89 c2                	mov    %eax,%edx
  801412:	8b 45 10             	mov    0x10(%ebp),%eax
  801415:	01 c2                	add    %eax,%edx
  801417:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80141a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141d:	01 c8                	add    %ecx,%eax
  80141f:	8a 00                	mov    (%eax),%al
  801421:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801423:	ff 45 f8             	incl   -0x8(%ebp)
  801426:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801429:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80142c:	7c d9                	jl     801407 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80142e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801431:	8b 45 10             	mov    0x10(%ebp),%eax
  801434:	01 d0                	add    %edx,%eax
  801436:	c6 00 00             	movb   $0x0,(%eax)
}
  801439:	90                   	nop
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80143f:	8b 45 14             	mov    0x14(%ebp),%eax
  801442:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801448:	8b 45 14             	mov    0x14(%ebp),%eax
  80144b:	8b 00                	mov    (%eax),%eax
  80144d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801454:	8b 45 10             	mov    0x10(%ebp),%eax
  801457:	01 d0                	add    %edx,%eax
  801459:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80145f:	eb 0c                	jmp    80146d <strsplit+0x31>
			*string++ = 0;
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	8d 50 01             	lea    0x1(%eax),%edx
  801467:	89 55 08             	mov    %edx,0x8(%ebp)
  80146a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	84 c0                	test   %al,%al
  801474:	74 18                	je     80148e <strsplit+0x52>
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	0f be c0             	movsbl %al,%eax
  80147e:	50                   	push   %eax
  80147f:	ff 75 0c             	pushl  0xc(%ebp)
  801482:	e8 13 fb ff ff       	call   800f9a <strchr>
  801487:	83 c4 08             	add    $0x8,%esp
  80148a:	85 c0                	test   %eax,%eax
  80148c:	75 d3                	jne    801461 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8a 00                	mov    (%eax),%al
  801493:	84 c0                	test   %al,%al
  801495:	74 5a                	je     8014f1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801497:	8b 45 14             	mov    0x14(%ebp),%eax
  80149a:	8b 00                	mov    (%eax),%eax
  80149c:	83 f8 0f             	cmp    $0xf,%eax
  80149f:	75 07                	jne    8014a8 <strsplit+0x6c>
		{
			return 0;
  8014a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a6:	eb 66                	jmp    80150e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ab:	8b 00                	mov    (%eax),%eax
  8014ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b0:	8b 55 14             	mov    0x14(%ebp),%edx
  8014b3:	89 0a                	mov    %ecx,(%edx)
  8014b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bf:	01 c2                	add    %eax,%edx
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014c6:	eb 03                	jmp    8014cb <strsplit+0x8f>
			string++;
  8014c8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	8a 00                	mov    (%eax),%al
  8014d0:	84 c0                	test   %al,%al
  8014d2:	74 8b                	je     80145f <strsplit+0x23>
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	8a 00                	mov    (%eax),%al
  8014d9:	0f be c0             	movsbl %al,%eax
  8014dc:	50                   	push   %eax
  8014dd:	ff 75 0c             	pushl  0xc(%ebp)
  8014e0:	e8 b5 fa ff ff       	call   800f9a <strchr>
  8014e5:	83 c4 08             	add    $0x8,%esp
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	74 dc                	je     8014c8 <strsplit+0x8c>
			string++;
	}
  8014ec:	e9 6e ff ff ff       	jmp    80145f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014f1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f5:	8b 00                	mov    (%eax),%eax
  8014f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801501:	01 d0                	add    %edx,%eax
  801503:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801509:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  801516:	a1 28 30 80 00       	mov    0x803028,%eax
  80151b:	85 c0                	test   %eax,%eax
  80151d:	75 33                	jne    801552 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  80151f:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  801526:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  801529:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  801530:	00 00 a0 
		spaces[0].pages = numPages;
  801533:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  80153a:	00 02 00 
		spaces[0].isFree = 1;
  80153d:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  801544:	00 00 00 
		arraySize++;
  801547:	a1 28 30 80 00       	mov    0x803028,%eax
  80154c:	40                   	inc    %eax
  80154d:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  801552:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  801559:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  801560:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801567:	8b 55 08             	mov    0x8(%ebp),%edx
  80156a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80156d:	01 d0                	add    %edx,%eax
  80156f:	48                   	dec    %eax
  801570:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801576:	ba 00 00 00 00       	mov    $0x0,%edx
  80157b:	f7 75 e8             	divl   -0x18(%ebp)
  80157e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801581:	29 d0                	sub    %edx,%eax
  801583:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	c1 e8 0c             	shr    $0xc,%eax
  80158c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  80158f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801596:	eb 57                	jmp    8015ef <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  801598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159b:	c1 e0 04             	shl    $0x4,%eax
  80159e:	05 2c 31 80 00       	add    $0x80312c,%eax
  8015a3:	8b 00                	mov    (%eax),%eax
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	74 42                	je     8015eb <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  8015a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ac:	c1 e0 04             	shl    $0x4,%eax
  8015af:	05 28 31 80 00       	add    $0x803128,%eax
  8015b4:	8b 00                	mov    (%eax),%eax
  8015b6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8015b9:	7c 31                	jl     8015ec <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  8015bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015be:	c1 e0 04             	shl    $0x4,%eax
  8015c1:	05 28 31 80 00       	add    $0x803128,%eax
  8015c6:	8b 00                	mov    (%eax),%eax
  8015c8:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8015cb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015ce:	7d 1c                	jge    8015ec <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  8015d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d3:	c1 e0 04             	shl    $0x4,%eax
  8015d6:	05 28 31 80 00       	add    $0x803128,%eax
  8015db:	8b 00                	mov    (%eax),%eax
  8015dd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8015e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  8015e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015e9:	eb 01                	jmp    8015ec <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  8015eb:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  8015ec:	ff 45 ec             	incl   -0x14(%ebp)
  8015ef:	a1 28 30 80 00       	mov    0x803028,%eax
  8015f4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8015f7:	7c 9f                	jl     801598 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  8015f9:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8015fd:	75 0a                	jne    801609 <malloc+0xf9>
	{
		return NULL;
  8015ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801604:	e9 34 01 00 00       	jmp    80173d <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  801609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160c:	c1 e0 04             	shl    $0x4,%eax
  80160f:	05 28 31 80 00       	add    $0x803128,%eax
  801614:	8b 00                	mov    (%eax),%eax
  801616:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801619:	75 38                	jne    801653 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  80161b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161e:	c1 e0 04             	shl    $0x4,%eax
  801621:	05 2c 31 80 00       	add    $0x80312c,%eax
  801626:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  80162c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80162f:	c1 e0 0c             	shl    $0xc,%eax
  801632:	89 c2                	mov    %eax,%edx
  801634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801637:	c1 e0 04             	shl    $0x4,%eax
  80163a:	05 20 31 80 00       	add    $0x803120,%eax
  80163f:	8b 00                	mov    (%eax),%eax
  801641:	83 ec 08             	sub    $0x8,%esp
  801644:	52                   	push   %edx
  801645:	50                   	push   %eax
  801646:	e8 01 06 00 00       	call   801c4c <sys_allocateMem>
  80164b:	83 c4 10             	add    $0x10,%esp
  80164e:	e9 dd 00 00 00       	jmp    801730 <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  801653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801656:	c1 e0 04             	shl    $0x4,%eax
  801659:	05 20 31 80 00       	add    $0x803120,%eax
  80165e:	8b 00                	mov    (%eax),%eax
  801660:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801663:	c1 e2 0c             	shl    $0xc,%edx
  801666:	01 d0                	add    %edx,%eax
  801668:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  80166b:	a1 28 30 80 00       	mov    0x803028,%eax
  801670:	c1 e0 04             	shl    $0x4,%eax
  801673:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  801679:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80167c:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  80167e:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801687:	c1 e0 04             	shl    $0x4,%eax
  80168a:	05 24 31 80 00       	add    $0x803124,%eax
  80168f:	8b 00                	mov    (%eax),%eax
  801691:	c1 e2 04             	shl    $0x4,%edx
  801694:	81 c2 24 31 80 00    	add    $0x803124,%edx
  80169a:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  80169c:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8016a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a5:	c1 e0 04             	shl    $0x4,%eax
  8016a8:	05 28 31 80 00       	add    $0x803128,%eax
  8016ad:	8b 00                	mov    (%eax),%eax
  8016af:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8016b2:	c1 e2 04             	shl    $0x4,%edx
  8016b5:	81 c2 28 31 80 00    	add    $0x803128,%edx
  8016bb:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  8016bd:	a1 28 30 80 00       	mov    0x803028,%eax
  8016c2:	c1 e0 04             	shl    $0x4,%eax
  8016c5:	05 2c 31 80 00       	add    $0x80312c,%eax
  8016ca:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  8016d0:	a1 28 30 80 00       	mov    0x803028,%eax
  8016d5:	40                   	inc    %eax
  8016d6:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  8016db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016de:	c1 e0 04             	shl    $0x4,%eax
  8016e1:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  8016e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016ea:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  8016ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ef:	c1 e0 04             	shl    $0x4,%eax
  8016f2:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  8016f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016fb:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  8016fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801700:	c1 e0 04             	shl    $0x4,%eax
  801703:	05 2c 31 80 00       	add    $0x80312c,%eax
  801708:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  80170e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801711:	c1 e0 0c             	shl    $0xc,%eax
  801714:	89 c2                	mov    %eax,%edx
  801716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801719:	c1 e0 04             	shl    $0x4,%eax
  80171c:	05 20 31 80 00       	add    $0x803120,%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	83 ec 08             	sub    $0x8,%esp
  801726:	52                   	push   %edx
  801727:	50                   	push   %eax
  801728:	e8 1f 05 00 00       	call   801c4c <sys_allocateMem>
  80172d:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  801730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801733:	c1 e0 04             	shl    $0x4,%eax
  801736:	05 20 31 80 00       	add    $0x803120,%eax
  80173b:	8b 00                	mov    (%eax),%eax
	}


}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  801745:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  80174c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801753:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80175a:	eb 3f                	jmp    80179b <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  80175c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175f:	c1 e0 04             	shl    $0x4,%eax
  801762:	05 20 31 80 00       	add    $0x803120,%eax
  801767:	8b 00                	mov    (%eax),%eax
  801769:	3b 45 08             	cmp    0x8(%ebp),%eax
  80176c:	75 2a                	jne    801798 <free+0x59>
		{
			index=i;
  80176e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801771:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  801774:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801777:	c1 e0 04             	shl    $0x4,%eax
  80177a:	05 28 31 80 00       	add    $0x803128,%eax
  80177f:	8b 00                	mov    (%eax),%eax
  801781:	c1 e0 0c             	shl    $0xc,%eax
  801784:	89 c2                	mov    %eax,%edx
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	83 ec 08             	sub    $0x8,%esp
  80178c:	52                   	push   %edx
  80178d:	50                   	push   %eax
  80178e:	e8 9d 04 00 00       	call   801c30 <sys_freeMem>
  801793:	83 c4 10             	add    $0x10,%esp
			break;
  801796:	eb 0d                	jmp    8017a5 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  801798:	ff 45 ec             	incl   -0x14(%ebp)
  80179b:	a1 28 30 80 00       	mov    0x803028,%eax
  8017a0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8017a3:	7c b7                	jl     80175c <free+0x1d>
			break;
		}

	}

	if(index == -1)
  8017a5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8017a9:	75 17                	jne    8017c2 <free+0x83>
	{
		panic("Error");
  8017ab:	83 ec 04             	sub    $0x4,%esp
  8017ae:	68 50 29 80 00       	push   $0x802950
  8017b3:	68 81 00 00 00       	push   $0x81
  8017b8:	68 56 29 80 00       	push   $0x802956
  8017bd:	e8 22 ed ff ff       	call   8004e4 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  8017c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8017c9:	e9 cc 00 00 00       	jmp    80189a <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  8017ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017d1:	c1 e0 04             	shl    $0x4,%eax
  8017d4:	05 2c 31 80 00       	add    $0x80312c,%eax
  8017d9:	8b 00                	mov    (%eax),%eax
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	0f 84 b3 00 00 00    	je     801896 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  8017e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e6:	c1 e0 04             	shl    $0x4,%eax
  8017e9:	05 20 31 80 00       	add    $0x803120,%eax
  8017ee:	8b 10                	mov    (%eax),%edx
  8017f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017f3:	c1 e0 04             	shl    $0x4,%eax
  8017f6:	05 24 31 80 00       	add    $0x803124,%eax
  8017fb:	8b 00                	mov    (%eax),%eax
  8017fd:	39 c2                	cmp    %eax,%edx
  8017ff:	0f 85 92 00 00 00    	jne    801897 <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  801805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801808:	c1 e0 04             	shl    $0x4,%eax
  80180b:	05 24 31 80 00       	add    $0x803124,%eax
  801810:	8b 00                	mov    (%eax),%eax
  801812:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801815:	c1 e2 04             	shl    $0x4,%edx
  801818:	81 c2 24 31 80 00    	add    $0x803124,%edx
  80181e:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801820:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801823:	c1 e0 04             	shl    $0x4,%eax
  801826:	05 28 31 80 00       	add    $0x803128,%eax
  80182b:	8b 10                	mov    (%eax),%edx
  80182d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801830:	c1 e0 04             	shl    $0x4,%eax
  801833:	05 28 31 80 00       	add    $0x803128,%eax
  801838:	8b 00                	mov    (%eax),%eax
  80183a:	01 c2                	add    %eax,%edx
  80183c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80183f:	c1 e0 04             	shl    $0x4,%eax
  801842:	05 28 31 80 00       	add    $0x803128,%eax
  801847:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184c:	c1 e0 04             	shl    $0x4,%eax
  80184f:	05 20 31 80 00       	add    $0x803120,%eax
  801854:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  80185a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185d:	c1 e0 04             	shl    $0x4,%eax
  801860:	05 24 31 80 00       	add    $0x803124,%eax
  801865:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  80186b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186e:	c1 e0 04             	shl    $0x4,%eax
  801871:	05 28 31 80 00       	add    $0x803128,%eax
  801876:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  80187c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187f:	c1 e0 04             	shl    $0x4,%eax
  801882:	05 2c 31 80 00       	add    $0x80312c,%eax
  801887:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  80188d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801894:	eb 12                	jmp    8018a8 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801896:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801897:	ff 45 e8             	incl   -0x18(%ebp)
  80189a:	a1 28 30 80 00       	mov    0x803028,%eax
  80189f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8018a2:	0f 8c 26 ff ff ff    	jl     8017ce <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  8018a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8018af:	e9 cc 00 00 00       	jmp    801980 <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  8018b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018b7:	c1 e0 04             	shl    $0x4,%eax
  8018ba:	05 2c 31 80 00       	add    $0x80312c,%eax
  8018bf:	8b 00                	mov    (%eax),%eax
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	0f 84 b3 00 00 00    	je     80197c <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  8018c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cc:	c1 e0 04             	shl    $0x4,%eax
  8018cf:	05 24 31 80 00       	add    $0x803124,%eax
  8018d4:	8b 10                	mov    (%eax),%edx
  8018d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018d9:	c1 e0 04             	shl    $0x4,%eax
  8018dc:	05 20 31 80 00       	add    $0x803120,%eax
  8018e1:	8b 00                	mov    (%eax),%eax
  8018e3:	39 c2                	cmp    %eax,%edx
  8018e5:	0f 85 92 00 00 00    	jne    80197d <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  8018eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ee:	c1 e0 04             	shl    $0x4,%eax
  8018f1:	05 20 31 80 00       	add    $0x803120,%eax
  8018f6:	8b 00                	mov    (%eax),%eax
  8018f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018fb:	c1 e2 04             	shl    $0x4,%edx
  8018fe:	81 c2 20 31 80 00    	add    $0x803120,%edx
  801904:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801906:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801909:	c1 e0 04             	shl    $0x4,%eax
  80190c:	05 28 31 80 00       	add    $0x803128,%eax
  801911:	8b 10                	mov    (%eax),%edx
  801913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801916:	c1 e0 04             	shl    $0x4,%eax
  801919:	05 28 31 80 00       	add    $0x803128,%eax
  80191e:	8b 00                	mov    (%eax),%eax
  801920:	01 c2                	add    %eax,%edx
  801922:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801925:	c1 e0 04             	shl    $0x4,%eax
  801928:	05 28 31 80 00       	add    $0x803128,%eax
  80192d:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  80192f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801932:	c1 e0 04             	shl    $0x4,%eax
  801935:	05 20 31 80 00       	add    $0x803120,%eax
  80193a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801943:	c1 e0 04             	shl    $0x4,%eax
  801946:	05 24 31 80 00       	add    $0x803124,%eax
  80194b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801954:	c1 e0 04             	shl    $0x4,%eax
  801957:	05 28 31 80 00       	add    $0x803128,%eax
  80195c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801965:	c1 e0 04             	shl    $0x4,%eax
  801968:	05 2c 31 80 00       	add    $0x80312c,%eax
  80196d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801973:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  80197a:	eb 12                	jmp    80198e <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  80197c:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  80197d:	ff 45 e4             	incl   -0x1c(%ebp)
  801980:	a1 28 30 80 00       	mov    0x803028,%eax
  801985:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801988:	0f 8c 26 ff ff ff    	jl     8018b4 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  80198e:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801992:	75 11                	jne    8019a5 <free+0x266>
	{
		spaces[index].isFree = 1;
  801994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801997:	c1 e0 04             	shl    $0x4,%eax
  80199a:	05 2c 31 80 00       	add    $0x80312c,%eax
  80199f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  8019a5:	90                   	nop
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	83 ec 18             	sub    $0x18,%esp
  8019ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b1:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  8019b4:	83 ec 04             	sub    $0x4,%esp
  8019b7:	68 64 29 80 00       	push   $0x802964
  8019bc:	68 b9 00 00 00       	push   $0xb9
  8019c1:	68 56 29 80 00       	push   $0x802956
  8019c6:	e8 19 eb ff ff       	call   8004e4 <_panic>

008019cb <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019d1:	83 ec 04             	sub    $0x4,%esp
  8019d4:	68 64 29 80 00       	push   $0x802964
  8019d9:	68 bf 00 00 00       	push   $0xbf
  8019de:	68 56 29 80 00       	push   $0x802956
  8019e3:	e8 fc ea ff ff       	call   8004e4 <_panic>

008019e8 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019ee:	83 ec 04             	sub    $0x4,%esp
  8019f1:	68 64 29 80 00       	push   $0x802964
  8019f6:	68 c5 00 00 00       	push   $0xc5
  8019fb:	68 56 29 80 00       	push   $0x802956
  801a00:	e8 df ea ff ff       	call   8004e4 <_panic>

00801a05 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a0b:	83 ec 04             	sub    $0x4,%esp
  801a0e:	68 64 29 80 00       	push   $0x802964
  801a13:	68 ca 00 00 00       	push   $0xca
  801a18:	68 56 29 80 00       	push   $0x802956
  801a1d:	e8 c2 ea ff ff       	call   8004e4 <_panic>

00801a22 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a28:	83 ec 04             	sub    $0x4,%esp
  801a2b:	68 64 29 80 00       	push   $0x802964
  801a30:	68 d0 00 00 00       	push   $0xd0
  801a35:	68 56 29 80 00       	push   $0x802956
  801a3a:	e8 a5 ea ff ff       	call   8004e4 <_panic>

00801a3f <shrink>:
}
void shrink(uint32 newSize)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a45:	83 ec 04             	sub    $0x4,%esp
  801a48:	68 64 29 80 00       	push   $0x802964
  801a4d:	68 d4 00 00 00       	push   $0xd4
  801a52:	68 56 29 80 00       	push   $0x802956
  801a57:	e8 88 ea ff ff       	call   8004e4 <_panic>

00801a5c <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a62:	83 ec 04             	sub    $0x4,%esp
  801a65:	68 64 29 80 00       	push   $0x802964
  801a6a:	68 d9 00 00 00       	push   $0xd9
  801a6f:	68 56 29 80 00       	push   $0x802956
  801a74:	e8 6b ea ff ff       	call   8004e4 <_panic>

00801a79 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	57                   	push   %edi
  801a7d:	56                   	push   %esi
  801a7e:	53                   	push   %ebx
  801a7f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a88:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a8b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a8e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a91:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a94:	cd 30                	int    $0x30
  801a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a9c:	83 c4 10             	add    $0x10,%esp
  801a9f:	5b                   	pop    %ebx
  801aa0:	5e                   	pop    %esi
  801aa1:	5f                   	pop    %edi
  801aa2:	5d                   	pop    %ebp
  801aa3:	c3                   	ret    

00801aa4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	8b 45 10             	mov    0x10(%ebp),%eax
  801aad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ab0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	52                   	push   %edx
  801abc:	ff 75 0c             	pushl  0xc(%ebp)
  801abf:	50                   	push   %eax
  801ac0:	6a 00                	push   $0x0
  801ac2:	e8 b2 ff ff ff       	call   801a79 <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	90                   	nop
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <sys_cgetc>:

int
sys_cgetc(void)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 01                	push   $0x1
  801adc:	e8 98 ff ff ff       	call   801a79 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	50                   	push   %eax
  801af5:	6a 05                	push   $0x5
  801af7:	e8 7d ff ff ff       	call   801a79 <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 02                	push   $0x2
  801b10:	e8 64 ff ff ff       	call   801a79 <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 03                	push   $0x3
  801b29:	e8 4b ff ff ff       	call   801a79 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 04                	push   $0x4
  801b42:	e8 32 ff ff ff       	call   801a79 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_env_exit>:


void sys_env_exit(void)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 06                	push   $0x6
  801b5b:	e8 19 ff ff ff       	call   801a79 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	90                   	nop
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	52                   	push   %edx
  801b76:	50                   	push   %eax
  801b77:	6a 07                	push   $0x7
  801b79:	e8 fb fe ff ff       	call   801a79 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	56                   	push   %esi
  801b87:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b88:	8b 75 18             	mov    0x18(%ebp),%esi
  801b8b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	56                   	push   %esi
  801b98:	53                   	push   %ebx
  801b99:	51                   	push   %ecx
  801b9a:	52                   	push   %edx
  801b9b:	50                   	push   %eax
  801b9c:	6a 08                	push   $0x8
  801b9e:	e8 d6 fe ff ff       	call   801a79 <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba9:	5b                   	pop    %ebx
  801baa:	5e                   	pop    %esi
  801bab:	5d                   	pop    %ebp
  801bac:	c3                   	ret    

00801bad <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	52                   	push   %edx
  801bbd:	50                   	push   %eax
  801bbe:	6a 09                	push   $0x9
  801bc0:	e8 b4 fe ff ff       	call   801a79 <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	ff 75 0c             	pushl  0xc(%ebp)
  801bd6:	ff 75 08             	pushl  0x8(%ebp)
  801bd9:	6a 0a                	push   $0xa
  801bdb:	e8 99 fe ff ff       	call   801a79 <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 0b                	push   $0xb
  801bf4:	e8 80 fe ff ff       	call   801a79 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 0c                	push   $0xc
  801c0d:	e8 67 fe ff ff       	call   801a79 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 0d                	push   $0xd
  801c26:	e8 4e fe ff ff       	call   801a79 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	ff 75 0c             	pushl  0xc(%ebp)
  801c3c:	ff 75 08             	pushl  0x8(%ebp)
  801c3f:	6a 11                	push   $0x11
  801c41:	e8 33 fe ff ff       	call   801a79 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
	return;
  801c49:	90                   	nop
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	ff 75 0c             	pushl  0xc(%ebp)
  801c58:	ff 75 08             	pushl  0x8(%ebp)
  801c5b:	6a 12                	push   $0x12
  801c5d:	e8 17 fe ff ff       	call   801a79 <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
	return ;
  801c65:	90                   	nop
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 0e                	push   $0xe
  801c77:	e8 fd fd ff ff       	call   801a79 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	ff 75 08             	pushl  0x8(%ebp)
  801c8f:	6a 0f                	push   $0xf
  801c91:	e8 e3 fd ff ff       	call   801a79 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 10                	push   $0x10
  801caa:	e8 ca fd ff ff       	call   801a79 <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
}
  801cb2:	90                   	nop
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 14                	push   $0x14
  801cc4:	e8 b0 fd ff ff       	call   801a79 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
}
  801ccc:	90                   	nop
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 15                	push   $0x15
  801cde:	e8 96 fd ff ff       	call   801a79 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	90                   	nop
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	83 ec 04             	sub    $0x4,%esp
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cf5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	50                   	push   %eax
  801d02:	6a 16                	push   $0x16
  801d04:	e8 70 fd ff ff       	call   801a79 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	90                   	nop
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 17                	push   $0x17
  801d1e:	e8 56 fd ff ff       	call   801a79 <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
}
  801d26:	90                   	nop
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	ff 75 0c             	pushl  0xc(%ebp)
  801d38:	50                   	push   %eax
  801d39:	6a 18                	push   $0x18
  801d3b:	e8 39 fd ff ff       	call   801a79 <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	52                   	push   %edx
  801d55:	50                   	push   %eax
  801d56:	6a 1b                	push   $0x1b
  801d58:	e8 1c fd ff ff       	call   801a79 <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	52                   	push   %edx
  801d72:	50                   	push   %eax
  801d73:	6a 19                	push   $0x19
  801d75:	e8 ff fc ff ff       	call   801a79 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
}
  801d7d:	90                   	nop
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	52                   	push   %edx
  801d90:	50                   	push   %eax
  801d91:	6a 1a                	push   $0x1a
  801d93:	e8 e1 fc ff ff       	call   801a79 <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	90                   	nop
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	83 ec 04             	sub    $0x4,%esp
  801da4:	8b 45 10             	mov    0x10(%ebp),%eax
  801da7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801daa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dad:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801db1:	8b 45 08             	mov    0x8(%ebp),%eax
  801db4:	6a 00                	push   $0x0
  801db6:	51                   	push   %ecx
  801db7:	52                   	push   %edx
  801db8:	ff 75 0c             	pushl  0xc(%ebp)
  801dbb:	50                   	push   %eax
  801dbc:	6a 1c                	push   $0x1c
  801dbe:	e8 b6 fc ff ff       	call   801a79 <syscall>
  801dc3:	83 c4 18             	add    $0x18,%esp
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801dcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	52                   	push   %edx
  801dd8:	50                   	push   %eax
  801dd9:	6a 1d                	push   $0x1d
  801ddb:	e8 99 fc ff ff       	call   801a79 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801de8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	51                   	push   %ecx
  801df6:	52                   	push   %edx
  801df7:	50                   	push   %eax
  801df8:	6a 1e                	push   $0x1e
  801dfa:	e8 7a fc ff ff       	call   801a79 <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	52                   	push   %edx
  801e14:	50                   	push   %eax
  801e15:	6a 1f                	push   $0x1f
  801e17:	e8 5d fc ff ff       	call   801a79 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 20                	push   $0x20
  801e30:	e8 44 fc ff ff       	call   801a79 <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	6a 00                	push   $0x0
  801e42:	ff 75 14             	pushl  0x14(%ebp)
  801e45:	ff 75 10             	pushl  0x10(%ebp)
  801e48:	ff 75 0c             	pushl  0xc(%ebp)
  801e4b:	50                   	push   %eax
  801e4c:	6a 21                	push   $0x21
  801e4e:	e8 26 fc ff ff       	call   801a79 <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	50                   	push   %eax
  801e67:	6a 22                	push   $0x22
  801e69:	e8 0b fc ff ff       	call   801a79 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	90                   	nop
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	50                   	push   %eax
  801e83:	6a 23                	push   $0x23
  801e85:	e8 ef fb ff ff       	call   801a79 <syscall>
  801e8a:	83 c4 18             	add    $0x18,%esp
}
  801e8d:	90                   	nop
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e96:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e99:	8d 50 04             	lea    0x4(%eax),%edx
  801e9c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	52                   	push   %edx
  801ea6:	50                   	push   %eax
  801ea7:	6a 24                	push   $0x24
  801ea9:	e8 cb fb ff ff       	call   801a79 <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
	return result;
  801eb1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eb7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801eba:	89 01                	mov    %eax,(%ecx)
  801ebc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	c9                   	leave  
  801ec3:	c2 04 00             	ret    $0x4

00801ec6 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	ff 75 10             	pushl  0x10(%ebp)
  801ed0:	ff 75 0c             	pushl  0xc(%ebp)
  801ed3:	ff 75 08             	pushl  0x8(%ebp)
  801ed6:	6a 13                	push   $0x13
  801ed8:	e8 9c fb ff ff       	call   801a79 <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee0:	90                   	nop
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 25                	push   $0x25
  801ef2:	e8 82 fb ff ff       	call   801a79 <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 04             	sub    $0x4,%esp
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f08:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	50                   	push   %eax
  801f15:	6a 26                	push   $0x26
  801f17:	e8 5d fb ff ff       	call   801a79 <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1f:	90                   	nop
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <rsttst>:
void rsttst()
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 28                	push   $0x28
  801f31:	e8 43 fb ff ff       	call   801a79 <syscall>
  801f36:	83 c4 18             	add    $0x18,%esp
	return ;
  801f39:	90                   	nop
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 04             	sub    $0x4,%esp
  801f42:	8b 45 14             	mov    0x14(%ebp),%eax
  801f45:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f48:	8b 55 18             	mov    0x18(%ebp),%edx
  801f4b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f4f:	52                   	push   %edx
  801f50:	50                   	push   %eax
  801f51:	ff 75 10             	pushl  0x10(%ebp)
  801f54:	ff 75 0c             	pushl  0xc(%ebp)
  801f57:	ff 75 08             	pushl  0x8(%ebp)
  801f5a:	6a 27                	push   $0x27
  801f5c:	e8 18 fb ff ff       	call   801a79 <syscall>
  801f61:	83 c4 18             	add    $0x18,%esp
	return ;
  801f64:	90                   	nop
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <chktst>:
void chktst(uint32 n)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	ff 75 08             	pushl  0x8(%ebp)
  801f75:	6a 29                	push   $0x29
  801f77:	e8 fd fa ff ff       	call   801a79 <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7f:	90                   	nop
}
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <inctst>:

void inctst()
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 2a                	push   $0x2a
  801f91:	e8 e3 fa ff ff       	call   801a79 <syscall>
  801f96:	83 c4 18             	add    $0x18,%esp
	return ;
  801f99:	90                   	nop
}
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    

00801f9c <gettst>:
uint32 gettst()
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 2b                	push   $0x2b
  801fab:	e8 c9 fa ff ff       	call   801a79 <syscall>
  801fb0:	83 c4 18             	add    $0x18,%esp
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 2c                	push   $0x2c
  801fc7:	e8 ad fa ff ff       	call   801a79 <syscall>
  801fcc:	83 c4 18             	add    $0x18,%esp
  801fcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fd2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fd6:	75 07                	jne    801fdf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fd8:	b8 01 00 00 00       	mov    $0x1,%eax
  801fdd:	eb 05                	jmp    801fe4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 2c                	push   $0x2c
  801ff8:	e8 7c fa ff ff       	call   801a79 <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
  802000:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802003:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802007:	75 07                	jne    802010 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802009:	b8 01 00 00 00       	mov    $0x1,%eax
  80200e:	eb 05                	jmp    802015 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 2c                	push   $0x2c
  802029:	e8 4b fa ff ff       	call   801a79 <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
  802031:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802034:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802038:	75 07                	jne    802041 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80203a:	b8 01 00 00 00       	mov    $0x1,%eax
  80203f:	eb 05                	jmp    802046 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 2c                	push   $0x2c
  80205a:	e8 1a fa ff ff       	call   801a79 <syscall>
  80205f:	83 c4 18             	add    $0x18,%esp
  802062:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802065:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802069:	75 07                	jne    802072 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80206b:	b8 01 00 00 00       	mov    $0x1,%eax
  802070:	eb 05                	jmp    802077 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802072:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	ff 75 08             	pushl  0x8(%ebp)
  802087:	6a 2d                	push   $0x2d
  802089:	e8 eb f9 ff ff       	call   801a79 <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
	return ;
  802091:	90                   	nop
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802098:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80209b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80209e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	6a 00                	push   $0x0
  8020a6:	53                   	push   %ebx
  8020a7:	51                   	push   %ecx
  8020a8:	52                   	push   %edx
  8020a9:	50                   	push   %eax
  8020aa:	6a 2e                	push   $0x2e
  8020ac:	e8 c8 f9 ff ff       	call   801a79 <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
}
  8020b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	52                   	push   %edx
  8020c9:	50                   	push   %eax
  8020ca:	6a 2f                	push   $0x2f
  8020cc:	e8 a8 f9 ff ff       	call   801a79 <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    
  8020d6:	66 90                	xchg   %ax,%ax

008020d8 <__udivdi3>:
  8020d8:	55                   	push   %ebp
  8020d9:	57                   	push   %edi
  8020da:	56                   	push   %esi
  8020db:	53                   	push   %ebx
  8020dc:	83 ec 1c             	sub    $0x1c,%esp
  8020df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8020e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020ef:	89 ca                	mov    %ecx,%edx
  8020f1:	89 f8                	mov    %edi,%eax
  8020f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020f7:	85 f6                	test   %esi,%esi
  8020f9:	75 2d                	jne    802128 <__udivdi3+0x50>
  8020fb:	39 cf                	cmp    %ecx,%edi
  8020fd:	77 65                	ja     802164 <__udivdi3+0x8c>
  8020ff:	89 fd                	mov    %edi,%ebp
  802101:	85 ff                	test   %edi,%edi
  802103:	75 0b                	jne    802110 <__udivdi3+0x38>
  802105:	b8 01 00 00 00       	mov    $0x1,%eax
  80210a:	31 d2                	xor    %edx,%edx
  80210c:	f7 f7                	div    %edi
  80210e:	89 c5                	mov    %eax,%ebp
  802110:	31 d2                	xor    %edx,%edx
  802112:	89 c8                	mov    %ecx,%eax
  802114:	f7 f5                	div    %ebp
  802116:	89 c1                	mov    %eax,%ecx
  802118:	89 d8                	mov    %ebx,%eax
  80211a:	f7 f5                	div    %ebp
  80211c:	89 cf                	mov    %ecx,%edi
  80211e:	89 fa                	mov    %edi,%edx
  802120:	83 c4 1c             	add    $0x1c,%esp
  802123:	5b                   	pop    %ebx
  802124:	5e                   	pop    %esi
  802125:	5f                   	pop    %edi
  802126:	5d                   	pop    %ebp
  802127:	c3                   	ret    
  802128:	39 ce                	cmp    %ecx,%esi
  80212a:	77 28                	ja     802154 <__udivdi3+0x7c>
  80212c:	0f bd fe             	bsr    %esi,%edi
  80212f:	83 f7 1f             	xor    $0x1f,%edi
  802132:	75 40                	jne    802174 <__udivdi3+0x9c>
  802134:	39 ce                	cmp    %ecx,%esi
  802136:	72 0a                	jb     802142 <__udivdi3+0x6a>
  802138:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80213c:	0f 87 9e 00 00 00    	ja     8021e0 <__udivdi3+0x108>
  802142:	b8 01 00 00 00       	mov    $0x1,%eax
  802147:	89 fa                	mov    %edi,%edx
  802149:	83 c4 1c             	add    $0x1c,%esp
  80214c:	5b                   	pop    %ebx
  80214d:	5e                   	pop    %esi
  80214e:	5f                   	pop    %edi
  80214f:	5d                   	pop    %ebp
  802150:	c3                   	ret    
  802151:	8d 76 00             	lea    0x0(%esi),%esi
  802154:	31 ff                	xor    %edi,%edi
  802156:	31 c0                	xor    %eax,%eax
  802158:	89 fa                	mov    %edi,%edx
  80215a:	83 c4 1c             	add    $0x1c,%esp
  80215d:	5b                   	pop    %ebx
  80215e:	5e                   	pop    %esi
  80215f:	5f                   	pop    %edi
  802160:	5d                   	pop    %ebp
  802161:	c3                   	ret    
  802162:	66 90                	xchg   %ax,%ax
  802164:	89 d8                	mov    %ebx,%eax
  802166:	f7 f7                	div    %edi
  802168:	31 ff                	xor    %edi,%edi
  80216a:	89 fa                	mov    %edi,%edx
  80216c:	83 c4 1c             	add    $0x1c,%esp
  80216f:	5b                   	pop    %ebx
  802170:	5e                   	pop    %esi
  802171:	5f                   	pop    %edi
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    
  802174:	bd 20 00 00 00       	mov    $0x20,%ebp
  802179:	89 eb                	mov    %ebp,%ebx
  80217b:	29 fb                	sub    %edi,%ebx
  80217d:	89 f9                	mov    %edi,%ecx
  80217f:	d3 e6                	shl    %cl,%esi
  802181:	89 c5                	mov    %eax,%ebp
  802183:	88 d9                	mov    %bl,%cl
  802185:	d3 ed                	shr    %cl,%ebp
  802187:	89 e9                	mov    %ebp,%ecx
  802189:	09 f1                	or     %esi,%ecx
  80218b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80218f:	89 f9                	mov    %edi,%ecx
  802191:	d3 e0                	shl    %cl,%eax
  802193:	89 c5                	mov    %eax,%ebp
  802195:	89 d6                	mov    %edx,%esi
  802197:	88 d9                	mov    %bl,%cl
  802199:	d3 ee                	shr    %cl,%esi
  80219b:	89 f9                	mov    %edi,%ecx
  80219d:	d3 e2                	shl    %cl,%edx
  80219f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021a3:	88 d9                	mov    %bl,%cl
  8021a5:	d3 e8                	shr    %cl,%eax
  8021a7:	09 c2                	or     %eax,%edx
  8021a9:	89 d0                	mov    %edx,%eax
  8021ab:	89 f2                	mov    %esi,%edx
  8021ad:	f7 74 24 0c          	divl   0xc(%esp)
  8021b1:	89 d6                	mov    %edx,%esi
  8021b3:	89 c3                	mov    %eax,%ebx
  8021b5:	f7 e5                	mul    %ebp
  8021b7:	39 d6                	cmp    %edx,%esi
  8021b9:	72 19                	jb     8021d4 <__udivdi3+0xfc>
  8021bb:	74 0b                	je     8021c8 <__udivdi3+0xf0>
  8021bd:	89 d8                	mov    %ebx,%eax
  8021bf:	31 ff                	xor    %edi,%edi
  8021c1:	e9 58 ff ff ff       	jmp    80211e <__udivdi3+0x46>
  8021c6:	66 90                	xchg   %ax,%ax
  8021c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021cc:	89 f9                	mov    %edi,%ecx
  8021ce:	d3 e2                	shl    %cl,%edx
  8021d0:	39 c2                	cmp    %eax,%edx
  8021d2:	73 e9                	jae    8021bd <__udivdi3+0xe5>
  8021d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021d7:	31 ff                	xor    %edi,%edi
  8021d9:	e9 40 ff ff ff       	jmp    80211e <__udivdi3+0x46>
  8021de:	66 90                	xchg   %ax,%ax
  8021e0:	31 c0                	xor    %eax,%eax
  8021e2:	e9 37 ff ff ff       	jmp    80211e <__udivdi3+0x46>
  8021e7:	90                   	nop

008021e8 <__umoddi3>:
  8021e8:	55                   	push   %ebp
  8021e9:	57                   	push   %edi
  8021ea:	56                   	push   %esi
  8021eb:	53                   	push   %ebx
  8021ec:	83 ec 1c             	sub    $0x1c,%esp
  8021ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802203:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802207:	89 f3                	mov    %esi,%ebx
  802209:	89 fa                	mov    %edi,%edx
  80220b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80220f:	89 34 24             	mov    %esi,(%esp)
  802212:	85 c0                	test   %eax,%eax
  802214:	75 1a                	jne    802230 <__umoddi3+0x48>
  802216:	39 f7                	cmp    %esi,%edi
  802218:	0f 86 a2 00 00 00    	jbe    8022c0 <__umoddi3+0xd8>
  80221e:	89 c8                	mov    %ecx,%eax
  802220:	89 f2                	mov    %esi,%edx
  802222:	f7 f7                	div    %edi
  802224:	89 d0                	mov    %edx,%eax
  802226:	31 d2                	xor    %edx,%edx
  802228:	83 c4 1c             	add    $0x1c,%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5e                   	pop    %esi
  80222d:	5f                   	pop    %edi
  80222e:	5d                   	pop    %ebp
  80222f:	c3                   	ret    
  802230:	39 f0                	cmp    %esi,%eax
  802232:	0f 87 ac 00 00 00    	ja     8022e4 <__umoddi3+0xfc>
  802238:	0f bd e8             	bsr    %eax,%ebp
  80223b:	83 f5 1f             	xor    $0x1f,%ebp
  80223e:	0f 84 ac 00 00 00    	je     8022f0 <__umoddi3+0x108>
  802244:	bf 20 00 00 00       	mov    $0x20,%edi
  802249:	29 ef                	sub    %ebp,%edi
  80224b:	89 fe                	mov    %edi,%esi
  80224d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802251:	89 e9                	mov    %ebp,%ecx
  802253:	d3 e0                	shl    %cl,%eax
  802255:	89 d7                	mov    %edx,%edi
  802257:	89 f1                	mov    %esi,%ecx
  802259:	d3 ef                	shr    %cl,%edi
  80225b:	09 c7                	or     %eax,%edi
  80225d:	89 e9                	mov    %ebp,%ecx
  80225f:	d3 e2                	shl    %cl,%edx
  802261:	89 14 24             	mov    %edx,(%esp)
  802264:	89 d8                	mov    %ebx,%eax
  802266:	d3 e0                	shl    %cl,%eax
  802268:	89 c2                	mov    %eax,%edx
  80226a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80226e:	d3 e0                	shl    %cl,%eax
  802270:	89 44 24 04          	mov    %eax,0x4(%esp)
  802274:	8b 44 24 08          	mov    0x8(%esp),%eax
  802278:	89 f1                	mov    %esi,%ecx
  80227a:	d3 e8                	shr    %cl,%eax
  80227c:	09 d0                	or     %edx,%eax
  80227e:	d3 eb                	shr    %cl,%ebx
  802280:	89 da                	mov    %ebx,%edx
  802282:	f7 f7                	div    %edi
  802284:	89 d3                	mov    %edx,%ebx
  802286:	f7 24 24             	mull   (%esp)
  802289:	89 c6                	mov    %eax,%esi
  80228b:	89 d1                	mov    %edx,%ecx
  80228d:	39 d3                	cmp    %edx,%ebx
  80228f:	0f 82 87 00 00 00    	jb     80231c <__umoddi3+0x134>
  802295:	0f 84 91 00 00 00    	je     80232c <__umoddi3+0x144>
  80229b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80229f:	29 f2                	sub    %esi,%edx
  8022a1:	19 cb                	sbb    %ecx,%ebx
  8022a3:	89 d8                	mov    %ebx,%eax
  8022a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8022a9:	d3 e0                	shl    %cl,%eax
  8022ab:	89 e9                	mov    %ebp,%ecx
  8022ad:	d3 ea                	shr    %cl,%edx
  8022af:	09 d0                	or     %edx,%eax
  8022b1:	89 e9                	mov    %ebp,%ecx
  8022b3:	d3 eb                	shr    %cl,%ebx
  8022b5:	89 da                	mov    %ebx,%edx
  8022b7:	83 c4 1c             	add    $0x1c,%esp
  8022ba:	5b                   	pop    %ebx
  8022bb:	5e                   	pop    %esi
  8022bc:	5f                   	pop    %edi
  8022bd:	5d                   	pop    %ebp
  8022be:	c3                   	ret    
  8022bf:	90                   	nop
  8022c0:	89 fd                	mov    %edi,%ebp
  8022c2:	85 ff                	test   %edi,%edi
  8022c4:	75 0b                	jne    8022d1 <__umoddi3+0xe9>
  8022c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cb:	31 d2                	xor    %edx,%edx
  8022cd:	f7 f7                	div    %edi
  8022cf:	89 c5                	mov    %eax,%ebp
  8022d1:	89 f0                	mov    %esi,%eax
  8022d3:	31 d2                	xor    %edx,%edx
  8022d5:	f7 f5                	div    %ebp
  8022d7:	89 c8                	mov    %ecx,%eax
  8022d9:	f7 f5                	div    %ebp
  8022db:	89 d0                	mov    %edx,%eax
  8022dd:	e9 44 ff ff ff       	jmp    802226 <__umoddi3+0x3e>
  8022e2:	66 90                	xchg   %ax,%ax
  8022e4:	89 c8                	mov    %ecx,%eax
  8022e6:	89 f2                	mov    %esi,%edx
  8022e8:	83 c4 1c             	add    $0x1c,%esp
  8022eb:	5b                   	pop    %ebx
  8022ec:	5e                   	pop    %esi
  8022ed:	5f                   	pop    %edi
  8022ee:	5d                   	pop    %ebp
  8022ef:	c3                   	ret    
  8022f0:	3b 04 24             	cmp    (%esp),%eax
  8022f3:	72 06                	jb     8022fb <__umoddi3+0x113>
  8022f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8022f9:	77 0f                	ja     80230a <__umoddi3+0x122>
  8022fb:	89 f2                	mov    %esi,%edx
  8022fd:	29 f9                	sub    %edi,%ecx
  8022ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802303:	89 14 24             	mov    %edx,(%esp)
  802306:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80230a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80230e:	8b 14 24             	mov    (%esp),%edx
  802311:	83 c4 1c             	add    $0x1c,%esp
  802314:	5b                   	pop    %ebx
  802315:	5e                   	pop    %esi
  802316:	5f                   	pop    %edi
  802317:	5d                   	pop    %ebp
  802318:	c3                   	ret    
  802319:	8d 76 00             	lea    0x0(%esi),%esi
  80231c:	2b 04 24             	sub    (%esp),%eax
  80231f:	19 fa                	sbb    %edi,%edx
  802321:	89 d1                	mov    %edx,%ecx
  802323:	89 c6                	mov    %eax,%esi
  802325:	e9 71 ff ff ff       	jmp    80229b <__umoddi3+0xb3>
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802330:	72 ea                	jb     80231c <__umoddi3+0x134>
  802332:	89 d9                	mov    %ebx,%ecx
  802334:	e9 62 ff ff ff       	jmp    80229b <__umoddi3+0xb3>
