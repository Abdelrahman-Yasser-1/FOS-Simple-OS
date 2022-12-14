
obj/user/tst_freeRAM_2:     file format elf32-i386


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
  800031:	e8 ac 05 00 00       	call   8005e2 <libmain>
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
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp





	int Mega = 1024*1024;
  800043:	c7 45 f4 00 00 10 00 	movl   $0x100000,-0xc(%ebp)
	int kilo = 1024;
  80004a:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	char minByte = 1<<7;
  800051:	c6 45 ef 80          	movb   $0x80,-0x11(%ebp)
	char maxByte = 0x7F;
  800055:	c6 45 ee 7f          	movb   $0x7f,-0x12(%ebp)
	short minShort = 1<<15 ;
  800059:	66 c7 45 ec 00 80    	movw   $0x8000,-0x14(%ebp)
	short maxShort = 0x7FFF;
  80005f:	66 c7 45 ea ff 7f    	movw   $0x7fff,-0x16(%ebp)
	int minInt = 1<<31 ;
  800065:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006c:	c7 45 e0 ff ff ff 7f 	movl   $0x7fffffff,-0x20(%ebp)

	void* ptr_allocations[20] = {0};
  800073:	8d 95 4c ff ff ff    	lea    -0xb4(%ebp),%edx
  800079:	b9 14 00 00 00       	mov    $0x14,%ecx
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	89 d7                	mov    %edx,%edi
  800085:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//Load "fib" & "fos_helloWorld" programs into RAM
		cprintf("Loading Fib & fos_helloWorld programs into RAM...");
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	68 40 26 80 00       	push   $0x802640
  80008f:	e8 35 09 00 00       	call   8009c9 <cprintf>
  800094:	83 c4 10             	add    $0x10,%esp
		int32 envIdFib = sys_create_env("fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800097:	a1 20 30 80 00       	mov    0x803020,%eax
  80009c:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8000a2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a7:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  8000ad:	89 c1                	mov    %eax,%ecx
  8000af:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b4:	8b 40 74             	mov    0x74(%eax),%eax
  8000b7:	52                   	push   %edx
  8000b8:	51                   	push   %ecx
  8000b9:	50                   	push   %eax
  8000ba:	68 72 26 80 00       	push   $0x802672
  8000bf:	e8 b9 1f 00 00       	call   80207d <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 59 1d 00 00       	call   801e28 <sys_calculate_free_frames>
  8000cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int32 envIdHelloWorld = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d7:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ef:	8b 40 74             	mov    0x74(%eax),%eax
  8000f2:	52                   	push   %edx
  8000f3:	51                   	push   %ecx
  8000f4:	50                   	push   %eax
  8000f5:	68 76 26 80 00       	push   $0x802676
  8000fa:	e8 7e 1f 00 00       	call   80207d <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  800105:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800108:	e8 1b 1d 00 00       	call   801e28 <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	89 45 d0             	mov    %eax,-0x30(%ebp)
		env_sleep(2000);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 d0 07 00 00       	push   $0x7d0
  80011c:	e8 f8 21 00 00       	call   802319 <env_sleep>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 85 26 80 00       	push   $0x802685
  80012c:	e8 98 08 00 00       	call   8009c9 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp

		//Load and run "fos_add"
		cprintf("Loading fos_add program into RAM...");
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 90 26 80 00       	push   $0x802690
  80013c:	e8 88 08 00 00       	call   8009c9 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
		int32 envIdFOSAdd= sys_create_env("fos_add", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800144:	a1 20 30 80 00       	mov    0x803020,%eax
  800149:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80014f:	a1 20 30 80 00       	mov    0x803020,%eax
  800154:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  80015a:	89 c1                	mov    %eax,%ecx
  80015c:	a1 20 30 80 00       	mov    0x803020,%eax
  800161:	8b 40 74             	mov    0x74(%eax),%eax
  800164:	52                   	push   %edx
  800165:	51                   	push   %ecx
  800166:	50                   	push   %eax
  800167:	68 b4 26 80 00       	push   $0x8026b4
  80016c:	e8 0c 1f 00 00       	call   80207d <sys_create_env>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 cc             	mov    %eax,-0x34(%ebp)
		env_sleep(2000);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 d0 07 00 00       	push   $0x7d0
  80017f:	e8 95 21 00 00       	call   802319 <env_sleep>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 85 26 80 00       	push   $0x802685
  80018f:	e8 35 08 00 00       	call   8009c9 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		cprintf("running fos_add program...\n\n");
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	68 bc 26 80 00       	push   $0x8026bc
  80019f:	e8 25 08 00 00       	call   8009c9 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdFOSAdd);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ad:	e8 e9 1e 00 00       	call   80209b <sys_run_env>
  8001b2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 d9 26 80 00       	push   $0x8026d9
  8001bd:	e8 07 08 00 00       	call   8009c9 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 88 13 00 00       	push   $0x1388
  8001cd:	e8 47 21 00 00       	call   802319 <env_sleep>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8001d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	50                   	push   %eax
  8001e1:	e8 6d 15 00 00       	call   801753 <malloc>
  8001e6:	83 c4 10             	add    $0x10,%esp
  8001e9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  8001ef:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8001f5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001fb:	01 c0                	add    %eax,%eax
  8001fd:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800200:	48                   	dec    %eax
  800201:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		byteArr[0] = minByte ;
  800204:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800207:	8a 55 ef             	mov    -0x11(%ebp),%dl
  80020a:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80020c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80020f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800212:	01 c2                	add    %eax,%edx
  800214:	8a 45 ee             	mov    -0x12(%ebp),%al
  800217:	88 02                	mov    %al,(%edx)

		//Allocate another 2 MB
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80021c:	01 c0                	add    %eax,%eax
  80021e:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 29 15 00 00       	call   801753 <malloc>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800233:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800239:	89 45 c0             	mov    %eax,-0x40(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  80023c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023f:	01 c0                	add    %eax,%eax
  800241:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800244:	d1 e8                	shr    %eax
  800246:	48                   	dec    %eax
  800247:	89 45 bc             	mov    %eax,-0x44(%ebp)
		shortArr[0] = minShort;
  80024a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80024d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800250:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800253:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800256:	01 c0                	add    %eax,%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80025d:	01 c2                	add    %eax,%edx
  80025f:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800263:	66 89 02             	mov    %ax,(%edx)

		//Allocate all remaining RAM (Here: it requires to free some RAM by removing exited program (fos_add))
		freeFrames = sys_calculate_free_frames() ;
  800266:	e8 bd 1b 00 00       	call   801e28 <sys_calculate_free_frames>
  80026b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(freeFrames*PAGE_SIZE);
  80026e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800271:	c1 e0 0c             	shl    $0xc,%eax
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	50                   	push   %eax
  800278:	e8 d6 14 00 00       	call   801753 <malloc>
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  800286:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  80028c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		int lastIndexOfInt = (freeFrames*PAGE_SIZE)/sizeof(int) - 1;
  80028f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800292:	c1 e0 0c             	shl    $0xc,%eax
  800295:	c1 e8 02             	shr    $0x2,%eax
  800298:	48                   	dec    %eax
  800299:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		intArr[0] = minInt;
  80029c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80029f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a2:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8002a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002b1:	01 c2                	add    %eax,%edx
  8002b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b6:	89 02                	mov    %eax,(%edx)

		//Allocate 7 KB after freeing some RAM
		ptr_allocations[3] = malloc(7*kilo);
  8002b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002bb:	89 d0                	mov    %edx,%eax
  8002bd:	01 c0                	add    %eax,%eax
  8002bf:	01 d0                	add    %edx,%eax
  8002c1:	01 c0                	add    %eax,%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	83 ec 0c             	sub    $0xc,%esp
  8002c8:	50                   	push   %eax
  8002c9:	e8 85 14 00 00       	call   801753 <malloc>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8002d7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8002dd:	89 45 b0             	mov    %eax,-0x50(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8002e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002e3:	89 d0                	mov    %edx,%eax
  8002e5:	01 c0                	add    %eax,%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	01 c0                	add    %eax,%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	c1 e8 03             	shr    $0x3,%eax
  8002f0:	48                   	dec    %eax
  8002f1:	89 45 ac             	mov    %eax,-0x54(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8002f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002f7:	8a 55 ef             	mov    -0x11(%ebp),%dl
  8002fa:	88 10                	mov    %dl,(%eax)
  8002fc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8002ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800302:	66 89 42 02          	mov    %ax,0x2(%edx)
  800306:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800309:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80030c:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  80030f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80031c:	01 c2                	add    %eax,%edx
  80031e:	8a 45 ee             	mov    -0x12(%ebp),%al
  800321:	88 02                	mov    %al,(%edx)
  800323:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800326:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80032d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800330:	01 c2                	add    %eax,%edx
  800332:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800336:	66 89 42 02          	mov    %ax,0x2(%edx)
  80033a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80033d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800344:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80034c:	89 42 04             	mov    %eax,0x4(%edx)

		cprintf("running fos_helloWorld program...\n\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 f0 26 80 00       	push   $0x8026f0
  800357:	e8 6d 06 00 00       	call   8009c9 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdHelloWorld);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d4             	pushl  -0x2c(%ebp)
  800365:	e8 31 1d 00 00       	call   80209b <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 d9 26 80 00       	push   $0x8026d9
  800375:	e8 4f 06 00 00       	call   8009c9 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	68 88 13 00 00       	push   $0x1388
  800385:	e8 8f 1f 00 00       	call   802319 <env_sleep>
  80038a:	83 c4 10             	add    $0x10,%esp

		//Allocate the remaining RAM + extra RAM by the size of helloWorld program (Here: it requires to free some RAM by removing exited & loaded program(s) (fos_helloWorld & fib))
		freeFrames = sys_calculate_free_frames() ;
  80038d:	e8 96 1a 00 00       	call   801e28 <sys_calculate_free_frames>
  800392:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc((freeFrames + helloWorldFrames)*PAGE_SIZE);
  800395:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039b:	01 d0                	add    %edx,%eax
  80039d:	c1 e0 0c             	shl    $0xc,%eax
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	50                   	push   %eax
  8003a4:	e8 aa 13 00 00       	call   801753 <malloc>
  8003a9:	83 c4 10             	add    $0x10,%esp
  8003ac:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		int *intArr2 = (int *) ptr_allocations[4];
  8003b2:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8003b8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		int lastIndexOfInt2 = ((freeFrames + helloWorldFrames)*PAGE_SIZE)/sizeof(int) - 1;
  8003bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 0c             	shl    $0xc,%eax
  8003c6:	c1 e8 02             	shr    $0x2,%eax
  8003c9:	48                   	dec    %eax
  8003ca:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		intArr2[0] = minInt;
  8003cd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003d3:	89 10                	mov    %edx,(%eax)
		intArr2[lastIndexOfInt2] = maxInt;
  8003d5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003df:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e2:	01 c2                	add    %eax,%edx
  8003e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e7:	89 02                	mov    %eax,(%edx)

		//Allocate 8 B after freeing the RAM
		ptr_allocations[5] = malloc(8);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	6a 08                	push   $0x8
  8003ee:	e8 60 13 00 00       	call   801753 <malloc>
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		int *intArr3 = (int *) ptr_allocations[5];
  8003fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800402:	89 45 a0             	mov    %eax,-0x60(%ebp)
		int lastIndexOfInt3 = 8/sizeof(int) - 1;
  800405:	c7 45 9c 01 00 00 00 	movl   $0x1,-0x64(%ebp)
		intArr3[0] = minInt;
  80040c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80040f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800412:	89 10                	mov    %edx,(%eax)
		intArr3[lastIndexOfInt3] = maxInt;
  800414:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800417:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80041e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800421:	01 c2                	add    %eax,%edx
  800423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800426:	89 02                	mov    %eax,(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800428:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80042b:	8a 00                	mov    (%eax),%al
  80042d:	3a 45 ef             	cmp    -0x11(%ebp),%al
  800430:	75 0f                	jne    800441 <_main+0x409>
  800432:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800435:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800438:	01 d0                	add    %edx,%eax
  80043a:	8a 00                	mov    (%eax),%al
  80043c:	3a 45 ee             	cmp    -0x12(%ebp),%al
  80043f:	74 14                	je     800455 <_main+0x41d>
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	68 14 27 80 00       	push   $0x802714
  800449:	6a 62                	push   $0x62
  80044b:	68 49 27 80 00       	push   $0x802749
  800450:	e8 d2 02 00 00       	call   800727 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800455:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800458:	66 8b 00             	mov    (%eax),%ax
  80045b:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  80045f:	75 15                	jne    800476 <_main+0x43e>
  800461:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800464:	01 c0                	add    %eax,%eax
  800466:	89 c2                	mov    %eax,%edx
  800468:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	66 8b 00             	mov    (%eax),%ax
  800470:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  800474:	74 14                	je     80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 14 27 80 00       	push   $0x802714
  80047e:	6a 63                	push   $0x63
  800480:	68 49 27 80 00       	push   $0x802749
  800485:	e8 9d 02 00 00       	call   800727 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  80048a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800492:	75 16                	jne    8004aa <_main+0x472>
  800494:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800497:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004a1:	01 d0                	add    %edx,%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 14 27 80 00       	push   $0x802714
  8004b2:	6a 64                	push   $0x64
  8004b4:	68 49 27 80 00       	push   $0x802749
  8004b9:	e8 69 02 00 00       	call   800727 <_panic>
		if (intArr2[0] 	!= minInt 	|| intArr2[lastIndexOfInt2] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004be:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c6:	75 16                	jne    8004de <_main+0x4a6>
  8004c8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <_main+0x4ba>
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 14 27 80 00       	push   $0x802714
  8004e6:	6a 65                	push   $0x65
  8004e8:	68 49 27 80 00       	push   $0x802749
  8004ed:	e8 35 02 00 00       	call   800727 <_panic>
		if (intArr3[0] 	!= minInt 	|| intArr3[lastIndexOfInt3] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004f2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fa:	75 16                	jne    800512 <_main+0x4da>
  8004fc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800506:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 14 27 80 00       	push   $0x802714
  80051a:	6a 66                	push   $0x66
  80051c:	68 49 27 80 00       	push   $0x802749
  800521:	e8 01 02 00 00       	call   800727 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  800526:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800529:	8a 00                	mov    (%eax),%al
  80052b:	3a 45 ef             	cmp    -0x11(%ebp),%al
  80052e:	75 16                	jne    800546 <_main+0x50e>
  800530:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800533:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80053a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80053d:	01 d0                	add    %edx,%eax
  80053f:	8a 00                	mov    (%eax),%al
  800541:	3a 45 ee             	cmp    -0x12(%ebp),%al
  800544:	74 14                	je     80055a <_main+0x522>
  800546:	83 ec 04             	sub    $0x4,%esp
  800549:	68 14 27 80 00       	push   $0x802714
  80054e:	6a 68                	push   $0x68
  800550:	68 49 27 80 00       	push   $0x802749
  800555:	e8 cd 01 00 00       	call   800727 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  80055a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80055d:	66 8b 40 02          	mov    0x2(%eax),%ax
  800561:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  800565:	75 19                	jne    800580 <_main+0x548>
  800567:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80056a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800571:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800574:	01 d0                	add    %edx,%eax
  800576:	66 8b 40 02          	mov    0x2(%eax),%ax
  80057a:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  80057e:	74 14                	je     800594 <_main+0x55c>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 14 27 80 00       	push   $0x802714
  800588:	6a 69                	push   $0x69
  80058a:	68 49 27 80 00       	push   $0x802749
  80058f:	e8 93 01 00 00       	call   800727 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800594:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800597:	8b 40 04             	mov    0x4(%eax),%eax
  80059a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80059d:	75 17                	jne    8005b6 <_main+0x57e>
  80059f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005ac:	01 d0                	add    %edx,%eax
  8005ae:	8b 40 04             	mov    0x4(%eax),%eax
  8005b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005b4:	74 14                	je     8005ca <_main+0x592>
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	68 14 27 80 00       	push   $0x802714
  8005be:	6a 6a                	push   $0x6a
  8005c0:	68 49 27 80 00       	push   $0x802749
  8005c5:	e8 5d 01 00 00       	call   800727 <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 60 27 80 00       	push   $0x802760
  8005d2:	e8 f2 03 00 00       	call   8009c9 <cprintf>
  8005d7:	83 c4 10             	add    $0x10,%esp

	return;
  8005da:	90                   	nop
}
  8005db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005de:	5b                   	pop    %ebx
  8005df:	5f                   	pop    %edi
  8005e0:	5d                   	pop    %ebp
  8005e1:	c3                   	ret    

008005e2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005e8:	e8 70 17 00 00       	call   801d5d <sys_getenvindex>
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f3:	89 d0                	mov    %edx,%eax
  8005f5:	c1 e0 03             	shl    $0x3,%eax
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800601:	01 c8                	add    %ecx,%eax
  800603:	01 c0                	add    %eax,%eax
  800605:	01 d0                	add    %edx,%eax
  800607:	01 c0                	add    %eax,%eax
  800609:	01 d0                	add    %edx,%eax
  80060b:	89 c2                	mov    %eax,%edx
  80060d:	c1 e2 05             	shl    $0x5,%edx
  800610:	29 c2                	sub    %eax,%edx
  800612:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800619:	89 c2                	mov    %eax,%edx
  80061b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800621:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800626:	a1 20 30 80 00       	mov    0x803020,%eax
  80062b:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800631:	84 c0                	test   %al,%al
  800633:	74 0f                	je     800644 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800635:	a1 20 30 80 00       	mov    0x803020,%eax
  80063a:	05 40 3c 01 00       	add    $0x13c40,%eax
  80063f:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800644:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800648:	7e 0a                	jle    800654 <libmain+0x72>
		binaryname = argv[0];
  80064a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	ff 75 08             	pushl  0x8(%ebp)
  80065d:	e8 d6 f9 ff ff       	call   800038 <_main>
  800662:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800665:	e8 8e 18 00 00       	call   801ef8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80066a:	83 ec 0c             	sub    $0xc,%esp
  80066d:	68 b4 27 80 00       	push   $0x8027b4
  800672:	e8 52 03 00 00       	call   8009c9 <cprintf>
  800677:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80067a:	a1 20 30 80 00       	mov    0x803020,%eax
  80067f:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800685:	a1 20 30 80 00       	mov    0x803020,%eax
  80068a:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800690:	83 ec 04             	sub    $0x4,%esp
  800693:	52                   	push   %edx
  800694:	50                   	push   %eax
  800695:	68 dc 27 80 00       	push   $0x8027dc
  80069a:	e8 2a 03 00 00       	call   8009c9 <cprintf>
  80069f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8006a2:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a7:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8006ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8006b2:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8006b8:	83 ec 04             	sub    $0x4,%esp
  8006bb:	52                   	push   %edx
  8006bc:	50                   	push   %eax
  8006bd:	68 04 28 80 00       	push   $0x802804
  8006c2:	e8 02 03 00 00       	call   8009c9 <cprintf>
  8006c7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8006cf:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	50                   	push   %eax
  8006d9:	68 45 28 80 00       	push   $0x802845
  8006de:	e8 e6 02 00 00       	call   8009c9 <cprintf>
  8006e3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006e6:	83 ec 0c             	sub    $0xc,%esp
  8006e9:	68 b4 27 80 00       	push   $0x8027b4
  8006ee:	e8 d6 02 00 00       	call   8009c9 <cprintf>
  8006f3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006f6:	e8 17 18 00 00       	call   801f12 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006fb:	e8 19 00 00 00       	call   800719 <exit>
}
  800700:	90                   	nop
  800701:	c9                   	leave  
  800702:	c3                   	ret    

00800703 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800703:	55                   	push   %ebp
  800704:	89 e5                	mov    %esp,%ebp
  800706:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800709:	83 ec 0c             	sub    $0xc,%esp
  80070c:	6a 00                	push   $0x0
  80070e:	e8 16 16 00 00       	call   801d29 <sys_env_destroy>
  800713:	83 c4 10             	add    $0x10,%esp
}
  800716:	90                   	nop
  800717:	c9                   	leave  
  800718:	c3                   	ret    

00800719 <exit>:

void
exit(void)
{
  800719:	55                   	push   %ebp
  80071a:	89 e5                	mov    %esp,%ebp
  80071c:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80071f:	e8 6b 16 00 00       	call   801d8f <sys_env_exit>
}
  800724:	90                   	nop
  800725:	c9                   	leave  
  800726:	c3                   	ret    

00800727 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800727:	55                   	push   %ebp
  800728:	89 e5                	mov    %esp,%ebp
  80072a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80072d:	8d 45 10             	lea    0x10(%ebp),%eax
  800730:	83 c0 04             	add    $0x4,%eax
  800733:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800736:	a1 18 31 80 00       	mov    0x803118,%eax
  80073b:	85 c0                	test   %eax,%eax
  80073d:	74 16                	je     800755 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80073f:	a1 18 31 80 00       	mov    0x803118,%eax
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	50                   	push   %eax
  800748:	68 5c 28 80 00       	push   $0x80285c
  80074d:	e8 77 02 00 00       	call   8009c9 <cprintf>
  800752:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800755:	a1 00 30 80 00       	mov    0x803000,%eax
  80075a:	ff 75 0c             	pushl  0xc(%ebp)
  80075d:	ff 75 08             	pushl  0x8(%ebp)
  800760:	50                   	push   %eax
  800761:	68 61 28 80 00       	push   $0x802861
  800766:	e8 5e 02 00 00       	call   8009c9 <cprintf>
  80076b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80076e:	8b 45 10             	mov    0x10(%ebp),%eax
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 f4             	pushl  -0xc(%ebp)
  800777:	50                   	push   %eax
  800778:	e8 e1 01 00 00       	call   80095e <vcprintf>
  80077d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	6a 00                	push   $0x0
  800785:	68 7d 28 80 00       	push   $0x80287d
  80078a:	e8 cf 01 00 00       	call   80095e <vcprintf>
  80078f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800792:	e8 82 ff ff ff       	call   800719 <exit>

	// should not return here
	while (1) ;
  800797:	eb fe                	jmp    800797 <_panic+0x70>

00800799 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80079f:	a1 20 30 80 00       	mov    0x803020,%eax
  8007a4:	8b 50 74             	mov    0x74(%eax),%edx
  8007a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007aa:	39 c2                	cmp    %eax,%edx
  8007ac:	74 14                	je     8007c2 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007ae:	83 ec 04             	sub    $0x4,%esp
  8007b1:	68 80 28 80 00       	push   $0x802880
  8007b6:	6a 26                	push   $0x26
  8007b8:	68 cc 28 80 00       	push   $0x8028cc
  8007bd:	e8 65 ff ff ff       	call   800727 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007d0:	e9 b6 00 00 00       	jmp    80088b <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8007d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	01 d0                	add    %edx,%eax
  8007e4:	8b 00                	mov    (%eax),%eax
  8007e6:	85 c0                	test   %eax,%eax
  8007e8:	75 08                	jne    8007f2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007ea:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007ed:	e9 96 00 00 00       	jmp    800888 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8007f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800800:	eb 5d                	jmp    80085f <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800802:	a1 20 30 80 00       	mov    0x803020,%eax
  800807:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80080d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800810:	c1 e2 04             	shl    $0x4,%edx
  800813:	01 d0                	add    %edx,%eax
  800815:	8a 40 04             	mov    0x4(%eax),%al
  800818:	84 c0                	test   %al,%al
  80081a:	75 40                	jne    80085c <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80081c:	a1 20 30 80 00       	mov    0x803020,%eax
  800821:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800827:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082a:	c1 e2 04             	shl    $0x4,%edx
  80082d:	01 d0                	add    %edx,%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800834:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800837:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80083c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80083e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800841:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	01 c8                	add    %ecx,%eax
  80084d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80084f:	39 c2                	cmp    %eax,%edx
  800851:	75 09                	jne    80085c <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800853:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80085a:	eb 12                	jmp    80086e <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80085c:	ff 45 e8             	incl   -0x18(%ebp)
  80085f:	a1 20 30 80 00       	mov    0x803020,%eax
  800864:	8b 50 74             	mov    0x74(%eax),%edx
  800867:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80086a:	39 c2                	cmp    %eax,%edx
  80086c:	77 94                	ja     800802 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80086e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800872:	75 14                	jne    800888 <CheckWSWithoutLastIndex+0xef>
			panic(
  800874:	83 ec 04             	sub    $0x4,%esp
  800877:	68 d8 28 80 00       	push   $0x8028d8
  80087c:	6a 3a                	push   $0x3a
  80087e:	68 cc 28 80 00       	push   $0x8028cc
  800883:	e8 9f fe ff ff       	call   800727 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800888:	ff 45 f0             	incl   -0x10(%ebp)
  80088b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800891:	0f 8c 3e ff ff ff    	jl     8007d5 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800897:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008a5:	eb 20                	jmp    8008c7 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8008ac:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8008b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b5:	c1 e2 04             	shl    $0x4,%edx
  8008b8:	01 d0                	add    %edx,%eax
  8008ba:	8a 40 04             	mov    0x4(%eax),%al
  8008bd:	3c 01                	cmp    $0x1,%al
  8008bf:	75 03                	jne    8008c4 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8008c1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008c4:	ff 45 e0             	incl   -0x20(%ebp)
  8008c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8008cc:	8b 50 74             	mov    0x74(%eax),%edx
  8008cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d2:	39 c2                	cmp    %eax,%edx
  8008d4:	77 d1                	ja     8008a7 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008dc:	74 14                	je     8008f2 <CheckWSWithoutLastIndex+0x159>
		panic(
  8008de:	83 ec 04             	sub    $0x4,%esp
  8008e1:	68 2c 29 80 00       	push   $0x80292c
  8008e6:	6a 44                	push   $0x44
  8008e8:	68 cc 28 80 00       	push   $0x8028cc
  8008ed:	e8 35 fe ff ff       	call   800727 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008f2:	90                   	nop
  8008f3:	c9                   	leave  
  8008f4:	c3                   	ret    

008008f5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	8d 48 01             	lea    0x1(%eax),%ecx
  800903:	8b 55 0c             	mov    0xc(%ebp),%edx
  800906:	89 0a                	mov    %ecx,(%edx)
  800908:	8b 55 08             	mov    0x8(%ebp),%edx
  80090b:	88 d1                	mov    %dl,%cl
  80090d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800910:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800914:	8b 45 0c             	mov    0xc(%ebp),%eax
  800917:	8b 00                	mov    (%eax),%eax
  800919:	3d ff 00 00 00       	cmp    $0xff,%eax
  80091e:	75 2c                	jne    80094c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800920:	a0 24 30 80 00       	mov    0x803024,%al
  800925:	0f b6 c0             	movzbl %al,%eax
  800928:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092b:	8b 12                	mov    (%edx),%edx
  80092d:	89 d1                	mov    %edx,%ecx
  80092f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800932:	83 c2 08             	add    $0x8,%edx
  800935:	83 ec 04             	sub    $0x4,%esp
  800938:	50                   	push   %eax
  800939:	51                   	push   %ecx
  80093a:	52                   	push   %edx
  80093b:	e8 a7 13 00 00       	call   801ce7 <sys_cputs>
  800940:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800943:	8b 45 0c             	mov    0xc(%ebp),%eax
  800946:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80094c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094f:	8b 40 04             	mov    0x4(%eax),%eax
  800952:	8d 50 01             	lea    0x1(%eax),%edx
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	89 50 04             	mov    %edx,0x4(%eax)
}
  80095b:	90                   	nop
  80095c:	c9                   	leave  
  80095d:	c3                   	ret    

0080095e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800967:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80096e:	00 00 00 
	b.cnt = 0;
  800971:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800978:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	ff 75 08             	pushl  0x8(%ebp)
  800981:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800987:	50                   	push   %eax
  800988:	68 f5 08 80 00       	push   $0x8008f5
  80098d:	e8 11 02 00 00       	call   800ba3 <vprintfmt>
  800992:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800995:	a0 24 30 80 00       	mov    0x803024,%al
  80099a:	0f b6 c0             	movzbl %al,%eax
  80099d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009a3:	83 ec 04             	sub    $0x4,%esp
  8009a6:	50                   	push   %eax
  8009a7:	52                   	push   %edx
  8009a8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009ae:	83 c0 08             	add    $0x8,%eax
  8009b1:	50                   	push   %eax
  8009b2:	e8 30 13 00 00       	call   801ce7 <sys_cputs>
  8009b7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009ba:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8009c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009cf:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009d6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e5:	50                   	push   %eax
  8009e6:	e8 73 ff ff ff       	call   80095e <vcprintf>
  8009eb:	83 c4 10             	add    $0x10,%esp
  8009ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009f4:	c9                   	leave  
  8009f5:	c3                   	ret    

008009f6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009fc:	e8 f7 14 00 00       	call   801ef8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a01:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a10:	50                   	push   %eax
  800a11:	e8 48 ff ff ff       	call   80095e <vcprintf>
  800a16:	83 c4 10             	add    $0x10,%esp
  800a19:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a1c:	e8 f1 14 00 00       	call   801f12 <sys_enable_interrupt>
	return cnt;
  800a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a24:	c9                   	leave  
  800a25:	c3                   	ret    

00800a26 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	53                   	push   %ebx
  800a2a:	83 ec 14             	sub    $0x14,%esp
  800a2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	8b 45 14             	mov    0x14(%ebp),%eax
  800a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a39:	8b 45 18             	mov    0x18(%ebp),%eax
  800a3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a41:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a44:	77 55                	ja     800a9b <printnum+0x75>
  800a46:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a49:	72 05                	jb     800a50 <printnum+0x2a>
  800a4b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a4e:	77 4b                	ja     800a9b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a50:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a53:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a56:	8b 45 18             	mov    0x18(%ebp),%eax
  800a59:	ba 00 00 00 00       	mov    $0x0,%edx
  800a5e:	52                   	push   %edx
  800a5f:	50                   	push   %eax
  800a60:	ff 75 f4             	pushl  -0xc(%ebp)
  800a63:	ff 75 f0             	pushl  -0x10(%ebp)
  800a66:	e8 65 19 00 00       	call   8023d0 <__udivdi3>
  800a6b:	83 c4 10             	add    $0x10,%esp
  800a6e:	83 ec 04             	sub    $0x4,%esp
  800a71:	ff 75 20             	pushl  0x20(%ebp)
  800a74:	53                   	push   %ebx
  800a75:	ff 75 18             	pushl  0x18(%ebp)
  800a78:	52                   	push   %edx
  800a79:	50                   	push   %eax
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	ff 75 08             	pushl  0x8(%ebp)
  800a80:	e8 a1 ff ff ff       	call   800a26 <printnum>
  800a85:	83 c4 20             	add    $0x20,%esp
  800a88:	eb 1a                	jmp    800aa4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a8a:	83 ec 08             	sub    $0x8,%esp
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	ff 75 20             	pushl  0x20(%ebp)
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	ff d0                	call   *%eax
  800a98:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a9b:	ff 4d 1c             	decl   0x1c(%ebp)
  800a9e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800aa2:	7f e6                	jg     800a8a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aa4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800aa7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab2:	53                   	push   %ebx
  800ab3:	51                   	push   %ecx
  800ab4:	52                   	push   %edx
  800ab5:	50                   	push   %eax
  800ab6:	e8 25 1a 00 00       	call   8024e0 <__umoddi3>
  800abb:	83 c4 10             	add    $0x10,%esp
  800abe:	05 94 2b 80 00       	add    $0x802b94,%eax
  800ac3:	8a 00                	mov    (%eax),%al
  800ac5:	0f be c0             	movsbl %al,%eax
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	50                   	push   %eax
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
}
  800ad7:	90                   	nop
  800ad8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800adb:	c9                   	leave  
  800adc:	c3                   	ret    

00800add <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ae4:	7e 1c                	jle    800b02 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	8b 00                	mov    (%eax),%eax
  800aeb:	8d 50 08             	lea    0x8(%eax),%edx
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	89 10                	mov    %edx,(%eax)
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	8b 00                	mov    (%eax),%eax
  800af8:	83 e8 08             	sub    $0x8,%eax
  800afb:	8b 50 04             	mov    0x4(%eax),%edx
  800afe:	8b 00                	mov    (%eax),%eax
  800b00:	eb 40                	jmp    800b42 <getuint+0x65>
	else if (lflag)
  800b02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b06:	74 1e                	je     800b26 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	8b 00                	mov    (%eax),%eax
  800b0d:	8d 50 04             	lea    0x4(%eax),%edx
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	89 10                	mov    %edx,(%eax)
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8b 00                	mov    (%eax),%eax
  800b1a:	83 e8 04             	sub    $0x4,%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b24:	eb 1c                	jmp    800b42 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	8d 50 04             	lea    0x4(%eax),%edx
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	89 10                	mov    %edx,(%eax)
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	8b 00                	mov    (%eax),%eax
  800b38:	83 e8 04             	sub    $0x4,%eax
  800b3b:	8b 00                	mov    (%eax),%eax
  800b3d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b47:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b4b:	7e 1c                	jle    800b69 <getint+0x25>
		return va_arg(*ap, long long);
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	8d 50 08             	lea    0x8(%eax),%edx
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	89 10                	mov    %edx,(%eax)
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	8b 00                	mov    (%eax),%eax
  800b5f:	83 e8 08             	sub    $0x8,%eax
  800b62:	8b 50 04             	mov    0x4(%eax),%edx
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	eb 38                	jmp    800ba1 <getint+0x5d>
	else if (lflag)
  800b69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6d:	74 1a                	je     800b89 <getint+0x45>
		return va_arg(*ap, long);
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	8d 50 04             	lea    0x4(%eax),%edx
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	89 10                	mov    %edx,(%eax)
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8b 00                	mov    (%eax),%eax
  800b81:	83 e8 04             	sub    $0x4,%eax
  800b84:	8b 00                	mov    (%eax),%eax
  800b86:	99                   	cltd   
  800b87:	eb 18                	jmp    800ba1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8b 00                	mov    (%eax),%eax
  800b8e:	8d 50 04             	lea    0x4(%eax),%edx
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	89 10                	mov    %edx,(%eax)
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	8b 00                	mov    (%eax),%eax
  800b9b:	83 e8 04             	sub    $0x4,%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	99                   	cltd   
}
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	56                   	push   %esi
  800ba7:	53                   	push   %ebx
  800ba8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bab:	eb 17                	jmp    800bc4 <vprintfmt+0x21>
			if (ch == '\0')
  800bad:	85 db                	test   %ebx,%ebx
  800baf:	0f 84 af 03 00 00    	je     800f64 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bb5:	83 ec 08             	sub    $0x8,%esp
  800bb8:	ff 75 0c             	pushl  0xc(%ebp)
  800bbb:	53                   	push   %ebx
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	ff d0                	call   *%eax
  800bc1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc7:	8d 50 01             	lea    0x1(%eax),%edx
  800bca:	89 55 10             	mov    %edx,0x10(%ebp)
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	0f b6 d8             	movzbl %al,%ebx
  800bd2:	83 fb 25             	cmp    $0x25,%ebx
  800bd5:	75 d6                	jne    800bad <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bd7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bdb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800be2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800be9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bf0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	8d 50 01             	lea    0x1(%eax),%edx
  800bfd:	89 55 10             	mov    %edx,0x10(%ebp)
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	0f b6 d8             	movzbl %al,%ebx
  800c05:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c08:	83 f8 55             	cmp    $0x55,%eax
  800c0b:	0f 87 2b 03 00 00    	ja     800f3c <vprintfmt+0x399>
  800c11:	8b 04 85 b8 2b 80 00 	mov    0x802bb8(,%eax,4),%eax
  800c18:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c1a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c1e:	eb d7                	jmp    800bf7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c20:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c24:	eb d1                	jmp    800bf7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c26:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c30:	89 d0                	mov    %edx,%eax
  800c32:	c1 e0 02             	shl    $0x2,%eax
  800c35:	01 d0                	add    %edx,%eax
  800c37:	01 c0                	add    %eax,%eax
  800c39:	01 d8                	add    %ebx,%eax
  800c3b:	83 e8 30             	sub    $0x30,%eax
  800c3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c41:	8b 45 10             	mov    0x10(%ebp),%eax
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c49:	83 fb 2f             	cmp    $0x2f,%ebx
  800c4c:	7e 3e                	jle    800c8c <vprintfmt+0xe9>
  800c4e:	83 fb 39             	cmp    $0x39,%ebx
  800c51:	7f 39                	jg     800c8c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c53:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c56:	eb d5                	jmp    800c2d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c58:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5b:	83 c0 04             	add    $0x4,%eax
  800c5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800c61:	8b 45 14             	mov    0x14(%ebp),%eax
  800c64:	83 e8 04             	sub    $0x4,%eax
  800c67:	8b 00                	mov    (%eax),%eax
  800c69:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c6c:	eb 1f                	jmp    800c8d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c72:	79 83                	jns    800bf7 <vprintfmt+0x54>
				width = 0;
  800c74:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c7b:	e9 77 ff ff ff       	jmp    800bf7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c80:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c87:	e9 6b ff ff ff       	jmp    800bf7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c8c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c91:	0f 89 60 ff ff ff    	jns    800bf7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c9d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ca4:	e9 4e ff ff ff       	jmp    800bf7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ca9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cac:	e9 46 ff ff ff       	jmp    800bf7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb4:	83 c0 04             	add    $0x4,%eax
  800cb7:	89 45 14             	mov    %eax,0x14(%ebp)
  800cba:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbd:	83 e8 04             	sub    $0x4,%eax
  800cc0:	8b 00                	mov    (%eax),%eax
  800cc2:	83 ec 08             	sub    $0x8,%esp
  800cc5:	ff 75 0c             	pushl  0xc(%ebp)
  800cc8:	50                   	push   %eax
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	ff d0                	call   *%eax
  800cce:	83 c4 10             	add    $0x10,%esp
			break;
  800cd1:	e9 89 02 00 00       	jmp    800f5f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd9:	83 c0 04             	add    $0x4,%eax
  800cdc:	89 45 14             	mov    %eax,0x14(%ebp)
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	83 e8 04             	sub    $0x4,%eax
  800ce5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ce7:	85 db                	test   %ebx,%ebx
  800ce9:	79 02                	jns    800ced <vprintfmt+0x14a>
				err = -err;
  800ceb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ced:	83 fb 64             	cmp    $0x64,%ebx
  800cf0:	7f 0b                	jg     800cfd <vprintfmt+0x15a>
  800cf2:	8b 34 9d 00 2a 80 00 	mov    0x802a00(,%ebx,4),%esi
  800cf9:	85 f6                	test   %esi,%esi
  800cfb:	75 19                	jne    800d16 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cfd:	53                   	push   %ebx
  800cfe:	68 a5 2b 80 00       	push   $0x802ba5
  800d03:	ff 75 0c             	pushl  0xc(%ebp)
  800d06:	ff 75 08             	pushl  0x8(%ebp)
  800d09:	e8 5e 02 00 00       	call   800f6c <printfmt>
  800d0e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d11:	e9 49 02 00 00       	jmp    800f5f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d16:	56                   	push   %esi
  800d17:	68 ae 2b 80 00       	push   $0x802bae
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	ff 75 08             	pushl  0x8(%ebp)
  800d22:	e8 45 02 00 00       	call   800f6c <printfmt>
  800d27:	83 c4 10             	add    $0x10,%esp
			break;
  800d2a:	e9 30 02 00 00       	jmp    800f5f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d32:	83 c0 04             	add    $0x4,%eax
  800d35:	89 45 14             	mov    %eax,0x14(%ebp)
  800d38:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3b:	83 e8 04             	sub    $0x4,%eax
  800d3e:	8b 30                	mov    (%eax),%esi
  800d40:	85 f6                	test   %esi,%esi
  800d42:	75 05                	jne    800d49 <vprintfmt+0x1a6>
				p = "(null)";
  800d44:	be b1 2b 80 00       	mov    $0x802bb1,%esi
			if (width > 0 && padc != '-')
  800d49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d4d:	7e 6d                	jle    800dbc <vprintfmt+0x219>
  800d4f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d53:	74 67                	je     800dbc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d58:	83 ec 08             	sub    $0x8,%esp
  800d5b:	50                   	push   %eax
  800d5c:	56                   	push   %esi
  800d5d:	e8 0c 03 00 00       	call   80106e <strnlen>
  800d62:	83 c4 10             	add    $0x10,%esp
  800d65:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d68:	eb 16                	jmp    800d80 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d6a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d6e:	83 ec 08             	sub    $0x8,%esp
  800d71:	ff 75 0c             	pushl  0xc(%ebp)
  800d74:	50                   	push   %eax
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	ff d0                	call   *%eax
  800d7a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d7d:	ff 4d e4             	decl   -0x1c(%ebp)
  800d80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d84:	7f e4                	jg     800d6a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d86:	eb 34                	jmp    800dbc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d88:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d8c:	74 1c                	je     800daa <vprintfmt+0x207>
  800d8e:	83 fb 1f             	cmp    $0x1f,%ebx
  800d91:	7e 05                	jle    800d98 <vprintfmt+0x1f5>
  800d93:	83 fb 7e             	cmp    $0x7e,%ebx
  800d96:	7e 12                	jle    800daa <vprintfmt+0x207>
					putch('?', putdat);
  800d98:	83 ec 08             	sub    $0x8,%esp
  800d9b:	ff 75 0c             	pushl  0xc(%ebp)
  800d9e:	6a 3f                	push   $0x3f
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	ff d0                	call   *%eax
  800da5:	83 c4 10             	add    $0x10,%esp
  800da8:	eb 0f                	jmp    800db9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 0c             	pushl  0xc(%ebp)
  800db0:	53                   	push   %ebx
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	ff d0                	call   *%eax
  800db6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800db9:	ff 4d e4             	decl   -0x1c(%ebp)
  800dbc:	89 f0                	mov    %esi,%eax
  800dbe:	8d 70 01             	lea    0x1(%eax),%esi
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	0f be d8             	movsbl %al,%ebx
  800dc6:	85 db                	test   %ebx,%ebx
  800dc8:	74 24                	je     800dee <vprintfmt+0x24b>
  800dca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dce:	78 b8                	js     800d88 <vprintfmt+0x1e5>
  800dd0:	ff 4d e0             	decl   -0x20(%ebp)
  800dd3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dd7:	79 af                	jns    800d88 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dd9:	eb 13                	jmp    800dee <vprintfmt+0x24b>
				putch(' ', putdat);
  800ddb:	83 ec 08             	sub    $0x8,%esp
  800dde:	ff 75 0c             	pushl  0xc(%ebp)
  800de1:	6a 20                	push   $0x20
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	ff d0                	call   *%eax
  800de8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800deb:	ff 4d e4             	decl   -0x1c(%ebp)
  800dee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df2:	7f e7                	jg     800ddb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800df4:	e9 66 01 00 00       	jmp    800f5f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800df9:	83 ec 08             	sub    $0x8,%esp
  800dfc:	ff 75 e8             	pushl  -0x18(%ebp)
  800dff:	8d 45 14             	lea    0x14(%ebp),%eax
  800e02:	50                   	push   %eax
  800e03:	e8 3c fd ff ff       	call   800b44 <getint>
  800e08:	83 c4 10             	add    $0x10,%esp
  800e0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e17:	85 d2                	test   %edx,%edx
  800e19:	79 23                	jns    800e3e <vprintfmt+0x29b>
				putch('-', putdat);
  800e1b:	83 ec 08             	sub    $0x8,%esp
  800e1e:	ff 75 0c             	pushl  0xc(%ebp)
  800e21:	6a 2d                	push   $0x2d
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	ff d0                	call   *%eax
  800e28:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e31:	f7 d8                	neg    %eax
  800e33:	83 d2 00             	adc    $0x0,%edx
  800e36:	f7 da                	neg    %edx
  800e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e3e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e45:	e9 bc 00 00 00       	jmp    800f06 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 e8             	pushl  -0x18(%ebp)
  800e50:	8d 45 14             	lea    0x14(%ebp),%eax
  800e53:	50                   	push   %eax
  800e54:	e8 84 fc ff ff       	call   800add <getuint>
  800e59:	83 c4 10             	add    $0x10,%esp
  800e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e62:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e69:	e9 98 00 00 00       	jmp    800f06 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e6e:	83 ec 08             	sub    $0x8,%esp
  800e71:	ff 75 0c             	pushl  0xc(%ebp)
  800e74:	6a 58                	push   $0x58
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	ff d0                	call   *%eax
  800e7b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e7e:	83 ec 08             	sub    $0x8,%esp
  800e81:	ff 75 0c             	pushl  0xc(%ebp)
  800e84:	6a 58                	push   $0x58
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	ff d0                	call   *%eax
  800e8b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e8e:	83 ec 08             	sub    $0x8,%esp
  800e91:	ff 75 0c             	pushl  0xc(%ebp)
  800e94:	6a 58                	push   $0x58
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	ff d0                	call   *%eax
  800e9b:	83 c4 10             	add    $0x10,%esp
			break;
  800e9e:	e9 bc 00 00 00       	jmp    800f5f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ea3:	83 ec 08             	sub    $0x8,%esp
  800ea6:	ff 75 0c             	pushl  0xc(%ebp)
  800ea9:	6a 30                	push   $0x30
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	ff d0                	call   *%eax
  800eb0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	ff 75 0c             	pushl  0xc(%ebp)
  800eb9:	6a 78                	push   $0x78
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	ff d0                	call   *%eax
  800ec0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ec3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec6:	83 c0 04             	add    $0x4,%eax
  800ec9:	89 45 14             	mov    %eax,0x14(%ebp)
  800ecc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecf:	83 e8 04             	sub    $0x4,%eax
  800ed2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ed4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ed7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ede:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ee5:	eb 1f                	jmp    800f06 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 e8             	pushl  -0x18(%ebp)
  800eed:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef0:	50                   	push   %eax
  800ef1:	e8 e7 fb ff ff       	call   800add <getuint>
  800ef6:	83 c4 10             	add    $0x10,%esp
  800ef9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800efc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800eff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f06:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f0d:	83 ec 04             	sub    $0x4,%esp
  800f10:	52                   	push   %edx
  800f11:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f14:	50                   	push   %eax
  800f15:	ff 75 f4             	pushl  -0xc(%ebp)
  800f18:	ff 75 f0             	pushl  -0x10(%ebp)
  800f1b:	ff 75 0c             	pushl  0xc(%ebp)
  800f1e:	ff 75 08             	pushl  0x8(%ebp)
  800f21:	e8 00 fb ff ff       	call   800a26 <printnum>
  800f26:	83 c4 20             	add    $0x20,%esp
			break;
  800f29:	eb 34                	jmp    800f5f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	ff 75 0c             	pushl  0xc(%ebp)
  800f31:	53                   	push   %ebx
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	ff d0                	call   *%eax
  800f37:	83 c4 10             	add    $0x10,%esp
			break;
  800f3a:	eb 23                	jmp    800f5f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f3c:	83 ec 08             	sub    $0x8,%esp
  800f3f:	ff 75 0c             	pushl  0xc(%ebp)
  800f42:	6a 25                	push   $0x25
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	ff d0                	call   *%eax
  800f49:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f4c:	ff 4d 10             	decl   0x10(%ebp)
  800f4f:	eb 03                	jmp    800f54 <vprintfmt+0x3b1>
  800f51:	ff 4d 10             	decl   0x10(%ebp)
  800f54:	8b 45 10             	mov    0x10(%ebp),%eax
  800f57:	48                   	dec    %eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	3c 25                	cmp    $0x25,%al
  800f5c:	75 f3                	jne    800f51 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f5e:	90                   	nop
		}
	}
  800f5f:	e9 47 fc ff ff       	jmp    800bab <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f64:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f68:	5b                   	pop    %ebx
  800f69:	5e                   	pop    %esi
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f72:	8d 45 10             	lea    0x10(%ebp),%eax
  800f75:	83 c0 04             	add    $0x4,%eax
  800f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f81:	50                   	push   %eax
  800f82:	ff 75 0c             	pushl  0xc(%ebp)
  800f85:	ff 75 08             	pushl  0x8(%ebp)
  800f88:	e8 16 fc ff ff       	call   800ba3 <vprintfmt>
  800f8d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f90:	90                   	nop
  800f91:	c9                   	leave  
  800f92:	c3                   	ret    

00800f93 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	8b 40 08             	mov    0x8(%eax),%eax
  800f9c:	8d 50 01             	lea    0x1(%eax),%edx
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	8b 10                	mov    (%eax),%edx
  800faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fad:	8b 40 04             	mov    0x4(%eax),%eax
  800fb0:	39 c2                	cmp    %eax,%edx
  800fb2:	73 12                	jae    800fc6 <sprintputch+0x33>
		*b->buf++ = ch;
  800fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb7:	8b 00                	mov    (%eax),%eax
  800fb9:	8d 48 01             	lea    0x1(%eax),%ecx
  800fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fbf:	89 0a                	mov    %ecx,(%edx)
  800fc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc4:	88 10                	mov    %dl,(%eax)
}
  800fc6:	90                   	nop
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    

00800fc9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	01 d0                	add    %edx,%eax
  800fe0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fee:	74 06                	je     800ff6 <vsnprintf+0x2d>
  800ff0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ff4:	7f 07                	jg     800ffd <vsnprintf+0x34>
		return -E_INVAL;
  800ff6:	b8 03 00 00 00       	mov    $0x3,%eax
  800ffb:	eb 20                	jmp    80101d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ffd:	ff 75 14             	pushl  0x14(%ebp)
  801000:	ff 75 10             	pushl  0x10(%ebp)
  801003:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801006:	50                   	push   %eax
  801007:	68 93 0f 80 00       	push   $0x800f93
  80100c:	e8 92 fb ff ff       	call   800ba3 <vprintfmt>
  801011:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801014:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801017:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80101a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80101d:	c9                   	leave  
  80101e:	c3                   	ret    

0080101f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801025:	8d 45 10             	lea    0x10(%ebp),%eax
  801028:	83 c0 04             	add    $0x4,%eax
  80102b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80102e:	8b 45 10             	mov    0x10(%ebp),%eax
  801031:	ff 75 f4             	pushl  -0xc(%ebp)
  801034:	50                   	push   %eax
  801035:	ff 75 0c             	pushl  0xc(%ebp)
  801038:	ff 75 08             	pushl  0x8(%ebp)
  80103b:	e8 89 ff ff ff       	call   800fc9 <vsnprintf>
  801040:	83 c4 10             	add    $0x10,%esp
  801043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801046:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801051:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801058:	eb 06                	jmp    801060 <strlen+0x15>
		n++;
  80105a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80105d:	ff 45 08             	incl   0x8(%ebp)
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	8a 00                	mov    (%eax),%al
  801065:	84 c0                	test   %al,%al
  801067:	75 f1                	jne    80105a <strlen+0xf>
		n++;
	return n;
  801069:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801074:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80107b:	eb 09                	jmp    801086 <strnlen+0x18>
		n++;
  80107d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801080:	ff 45 08             	incl   0x8(%ebp)
  801083:	ff 4d 0c             	decl   0xc(%ebp)
  801086:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80108a:	74 09                	je     801095 <strnlen+0x27>
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	84 c0                	test   %al,%al
  801093:	75 e8                	jne    80107d <strnlen+0xf>
		n++;
	return n;
  801095:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801098:	c9                   	leave  
  801099:	c3                   	ret    

0080109a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010a6:	90                   	nop
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	8d 50 01             	lea    0x1(%eax),%edx
  8010ad:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010b9:	8a 12                	mov    (%edx),%dl
  8010bb:	88 10                	mov    %dl,(%eax)
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	84 c0                	test   %al,%al
  8010c1:	75 e4                	jne    8010a7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010c6:	c9                   	leave  
  8010c7:	c3                   	ret    

008010c8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010db:	eb 1f                	jmp    8010fc <strncpy+0x34>
		*dst++ = *src;
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e0:	8d 50 01             	lea    0x1(%eax),%edx
  8010e3:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e9:	8a 12                	mov    (%edx),%dl
  8010eb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	84 c0                	test   %al,%al
  8010f4:	74 03                	je     8010f9 <strncpy+0x31>
			src++;
  8010f6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010f9:	ff 45 fc             	incl   -0x4(%ebp)
  8010fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ff:	3b 45 10             	cmp    0x10(%ebp),%eax
  801102:	72 d9                	jb     8010dd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801104:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801107:	c9                   	leave  
  801108:	c3                   	ret    

00801109 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801115:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801119:	74 30                	je     80114b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80111b:	eb 16                	jmp    801133 <strlcpy+0x2a>
			*dst++ = *src++;
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8d 50 01             	lea    0x1(%eax),%edx
  801123:	89 55 08             	mov    %edx,0x8(%ebp)
  801126:	8b 55 0c             	mov    0xc(%ebp),%edx
  801129:	8d 4a 01             	lea    0x1(%edx),%ecx
  80112c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80112f:	8a 12                	mov    (%edx),%dl
  801131:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801133:	ff 4d 10             	decl   0x10(%ebp)
  801136:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113a:	74 09                	je     801145 <strlcpy+0x3c>
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	84 c0                	test   %al,%al
  801143:	75 d8                	jne    80111d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80114b:	8b 55 08             	mov    0x8(%ebp),%edx
  80114e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801151:	29 c2                	sub    %eax,%edx
  801153:	89 d0                	mov    %edx,%eax
}
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80115a:	eb 06                	jmp    801162 <strcmp+0xb>
		p++, q++;
  80115c:	ff 45 08             	incl   0x8(%ebp)
  80115f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	84 c0                	test   %al,%al
  801169:	74 0e                	je     801179 <strcmp+0x22>
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 10                	mov    (%eax),%dl
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	38 c2                	cmp    %al,%dl
  801177:	74 e3                	je     80115c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	0f b6 d0             	movzbl %al,%edx
  801181:	8b 45 0c             	mov    0xc(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	0f b6 c0             	movzbl %al,%eax
  801189:	29 c2                	sub    %eax,%edx
  80118b:	89 d0                	mov    %edx,%eax
}
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    

0080118f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801192:	eb 09                	jmp    80119d <strncmp+0xe>
		n--, p++, q++;
  801194:	ff 4d 10             	decl   0x10(%ebp)
  801197:	ff 45 08             	incl   0x8(%ebp)
  80119a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80119d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a1:	74 17                	je     8011ba <strncmp+0x2b>
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	84 c0                	test   %al,%al
  8011aa:	74 0e                	je     8011ba <strncmp+0x2b>
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 10                	mov    (%eax),%dl
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	8a 00                	mov    (%eax),%al
  8011b6:	38 c2                	cmp    %al,%dl
  8011b8:	74 da                	je     801194 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011be:	75 07                	jne    8011c7 <strncmp+0x38>
		return 0;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c5:	eb 14                	jmp    8011db <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	0f b6 d0             	movzbl %al,%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	0f b6 c0             	movzbl %al,%eax
  8011d7:	29 c2                	sub    %eax,%edx
  8011d9:	89 d0                	mov    %edx,%eax
}
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    

008011dd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	83 ec 04             	sub    $0x4,%esp
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011e9:	eb 12                	jmp    8011fd <strchr+0x20>
		if (*s == c)
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011f3:	75 05                	jne    8011fa <strchr+0x1d>
			return (char *) s;
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	eb 11                	jmp    80120b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011fa:	ff 45 08             	incl   0x8(%ebp)
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	84 c0                	test   %al,%al
  801204:	75 e5                	jne    8011eb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801206:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 04             	sub    $0x4,%esp
  801213:	8b 45 0c             	mov    0xc(%ebp),%eax
  801216:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801219:	eb 0d                	jmp    801228 <strfind+0x1b>
		if (*s == c)
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801223:	74 0e                	je     801233 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801225:	ff 45 08             	incl   0x8(%ebp)
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	84 c0                	test   %al,%al
  80122f:	75 ea                	jne    80121b <strfind+0xe>
  801231:	eb 01                	jmp    801234 <strfind+0x27>
		if (*s == c)
			break;
  801233:	90                   	nop
	return (char *) s;
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801237:	c9                   	leave  
  801238:	c3                   	ret    

00801239 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
  80123c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801245:	8b 45 10             	mov    0x10(%ebp),%eax
  801248:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80124b:	eb 0e                	jmp    80125b <memset+0x22>
		*p++ = c;
  80124d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801250:	8d 50 01             	lea    0x1(%eax),%edx
  801253:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801256:	8b 55 0c             	mov    0xc(%ebp),%edx
  801259:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80125b:	ff 4d f8             	decl   -0x8(%ebp)
  80125e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801262:	79 e9                	jns    80124d <memset+0x14>
		*p++ = c;

	return v;
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801267:	c9                   	leave  
  801268:	c3                   	ret    

00801269 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
  80126c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80127b:	eb 16                	jmp    801293 <memcpy+0x2a>
		*d++ = *s++;
  80127d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801280:	8d 50 01             	lea    0x1(%eax),%edx
  801283:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801286:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801289:	8d 4a 01             	lea    0x1(%edx),%ecx
  80128c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80128f:	8a 12                	mov    (%edx),%dl
  801291:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801293:	8b 45 10             	mov    0x10(%ebp),%eax
  801296:	8d 50 ff             	lea    -0x1(%eax),%edx
  801299:	89 55 10             	mov    %edx,0x10(%ebp)
  80129c:	85 c0                	test   %eax,%eax
  80129e:	75 dd                	jne    80127d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012bd:	73 50                	jae    80130f <memmove+0x6a>
  8012bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c5:	01 d0                	add    %edx,%eax
  8012c7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012ca:	76 43                	jbe    80130f <memmove+0x6a>
		s += n;
  8012cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012d8:	eb 10                	jmp    8012ea <memmove+0x45>
			*--d = *--s;
  8012da:	ff 4d f8             	decl   -0x8(%ebp)
  8012dd:	ff 4d fc             	decl   -0x4(%ebp)
  8012e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e3:	8a 10                	mov    (%eax),%dl
  8012e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	75 e3                	jne    8012da <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012f7:	eb 23                	jmp    80131c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fc:	8d 50 01             	lea    0x1(%eax),%edx
  8012ff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801302:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801305:	8d 4a 01             	lea    0x1(%edx),%ecx
  801308:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80130b:	8a 12                	mov    (%edx),%dl
  80130d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80130f:	8b 45 10             	mov    0x10(%ebp),%eax
  801312:	8d 50 ff             	lea    -0x1(%eax),%edx
  801315:	89 55 10             	mov    %edx,0x10(%ebp)
  801318:	85 c0                	test   %eax,%eax
  80131a:	75 dd                	jne    8012f9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80132d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801330:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801333:	eb 2a                	jmp    80135f <memcmp+0x3e>
		if (*s1 != *s2)
  801335:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801338:	8a 10                	mov    (%eax),%dl
  80133a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	38 c2                	cmp    %al,%dl
  801341:	74 16                	je     801359 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801343:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	0f b6 d0             	movzbl %al,%edx
  80134b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	0f b6 c0             	movzbl %al,%eax
  801353:	29 c2                	sub    %eax,%edx
  801355:	89 d0                	mov    %edx,%eax
  801357:	eb 18                	jmp    801371 <memcmp+0x50>
		s1++, s2++;
  801359:	ff 45 fc             	incl   -0x4(%ebp)
  80135c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80135f:	8b 45 10             	mov    0x10(%ebp),%eax
  801362:	8d 50 ff             	lea    -0x1(%eax),%edx
  801365:	89 55 10             	mov    %edx,0x10(%ebp)
  801368:	85 c0                	test   %eax,%eax
  80136a:	75 c9                	jne    801335 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80136c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801379:	8b 55 08             	mov    0x8(%ebp),%edx
  80137c:	8b 45 10             	mov    0x10(%ebp),%eax
  80137f:	01 d0                	add    %edx,%eax
  801381:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801384:	eb 15                	jmp    80139b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	8a 00                	mov    (%eax),%al
  80138b:	0f b6 d0             	movzbl %al,%edx
  80138e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801391:	0f b6 c0             	movzbl %al,%eax
  801394:	39 c2                	cmp    %eax,%edx
  801396:	74 0d                	je     8013a5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801398:	ff 45 08             	incl   0x8(%ebp)
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013a1:	72 e3                	jb     801386 <memfind+0x13>
  8013a3:	eb 01                	jmp    8013a6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013a5:	90                   	nop
	return (void *) s;
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013a9:	c9                   	leave  
  8013aa:	c3                   	ret    

008013ab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013bf:	eb 03                	jmp    8013c4 <strtol+0x19>
		s++;
  8013c1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	8a 00                	mov    (%eax),%al
  8013c9:	3c 20                	cmp    $0x20,%al
  8013cb:	74 f4                	je     8013c1 <strtol+0x16>
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	3c 09                	cmp    $0x9,%al
  8013d4:	74 eb                	je     8013c1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8a 00                	mov    (%eax),%al
  8013db:	3c 2b                	cmp    $0x2b,%al
  8013dd:	75 05                	jne    8013e4 <strtol+0x39>
		s++;
  8013df:	ff 45 08             	incl   0x8(%ebp)
  8013e2:	eb 13                	jmp    8013f7 <strtol+0x4c>
	else if (*s == '-')
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	3c 2d                	cmp    $0x2d,%al
  8013eb:	75 0a                	jne    8013f7 <strtol+0x4c>
		s++, neg = 1;
  8013ed:	ff 45 08             	incl   0x8(%ebp)
  8013f0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013fb:	74 06                	je     801403 <strtol+0x58>
  8013fd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801401:	75 20                	jne    801423 <strtol+0x78>
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	3c 30                	cmp    $0x30,%al
  80140a:	75 17                	jne    801423 <strtol+0x78>
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	40                   	inc    %eax
  801410:	8a 00                	mov    (%eax),%al
  801412:	3c 78                	cmp    $0x78,%al
  801414:	75 0d                	jne    801423 <strtol+0x78>
		s += 2, base = 16;
  801416:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80141a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801421:	eb 28                	jmp    80144b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801423:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801427:	75 15                	jne    80143e <strtol+0x93>
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	3c 30                	cmp    $0x30,%al
  801430:	75 0c                	jne    80143e <strtol+0x93>
		s++, base = 8;
  801432:	ff 45 08             	incl   0x8(%ebp)
  801435:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80143c:	eb 0d                	jmp    80144b <strtol+0xa0>
	else if (base == 0)
  80143e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801442:	75 07                	jne    80144b <strtol+0xa0>
		base = 10;
  801444:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	3c 2f                	cmp    $0x2f,%al
  801452:	7e 19                	jle    80146d <strtol+0xc2>
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	3c 39                	cmp    $0x39,%al
  80145b:	7f 10                	jg     80146d <strtol+0xc2>
			dig = *s - '0';
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	0f be c0             	movsbl %al,%eax
  801465:	83 e8 30             	sub    $0x30,%eax
  801468:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80146b:	eb 42                	jmp    8014af <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3c 60                	cmp    $0x60,%al
  801474:	7e 19                	jle    80148f <strtol+0xe4>
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	3c 7a                	cmp    $0x7a,%al
  80147d:	7f 10                	jg     80148f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	0f be c0             	movsbl %al,%eax
  801487:	83 e8 57             	sub    $0x57,%eax
  80148a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80148d:	eb 20                	jmp    8014af <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	3c 40                	cmp    $0x40,%al
  801496:	7e 39                	jle    8014d1 <strtol+0x126>
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 5a                	cmp    $0x5a,%al
  80149f:	7f 30                	jg     8014d1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	0f be c0             	movsbl %al,%eax
  8014a9:	83 e8 37             	sub    $0x37,%eax
  8014ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014b5:	7d 19                	jge    8014d0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014b7:	ff 45 08             	incl   0x8(%ebp)
  8014ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014bd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014c1:	89 c2                	mov    %eax,%edx
  8014c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c6:	01 d0                	add    %edx,%eax
  8014c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014cb:	e9 7b ff ff ff       	jmp    80144b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014d0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014d5:	74 08                	je     8014df <strtol+0x134>
		*endptr = (char *) s;
  8014d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014da:	8b 55 08             	mov    0x8(%ebp),%edx
  8014dd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014e3:	74 07                	je     8014ec <strtol+0x141>
  8014e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e8:	f7 d8                	neg    %eax
  8014ea:	eb 03                	jmp    8014ef <strtol+0x144>
  8014ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    

008014f1 <ltostr>:

void
ltostr(long value, char *str)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801505:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801509:	79 13                	jns    80151e <ltostr+0x2d>
	{
		neg = 1;
  80150b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801512:	8b 45 0c             	mov    0xc(%ebp),%eax
  801515:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801518:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80151b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801526:	99                   	cltd   
  801527:	f7 f9                	idiv   %ecx
  801529:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80152c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152f:	8d 50 01             	lea    0x1(%eax),%edx
  801532:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801535:	89 c2                	mov    %eax,%edx
  801537:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153a:	01 d0                	add    %edx,%eax
  80153c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80153f:	83 c2 30             	add    $0x30,%edx
  801542:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801544:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801547:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80154c:	f7 e9                	imul   %ecx
  80154e:	c1 fa 02             	sar    $0x2,%edx
  801551:	89 c8                	mov    %ecx,%eax
  801553:	c1 f8 1f             	sar    $0x1f,%eax
  801556:	29 c2                	sub    %eax,%edx
  801558:	89 d0                	mov    %edx,%eax
  80155a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80155d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801560:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801565:	f7 e9                	imul   %ecx
  801567:	c1 fa 02             	sar    $0x2,%edx
  80156a:	89 c8                	mov    %ecx,%eax
  80156c:	c1 f8 1f             	sar    $0x1f,%eax
  80156f:	29 c2                	sub    %eax,%edx
  801571:	89 d0                	mov    %edx,%eax
  801573:	c1 e0 02             	shl    $0x2,%eax
  801576:	01 d0                	add    %edx,%eax
  801578:	01 c0                	add    %eax,%eax
  80157a:	29 c1                	sub    %eax,%ecx
  80157c:	89 ca                	mov    %ecx,%edx
  80157e:	85 d2                	test   %edx,%edx
  801580:	75 9c                	jne    80151e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801582:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801589:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158c:	48                   	dec    %eax
  80158d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801590:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801594:	74 3d                	je     8015d3 <ltostr+0xe2>
		start = 1 ;
  801596:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80159d:	eb 34                	jmp    8015d3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80159f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a5:	01 d0                	add    %edx,%eax
  8015a7:	8a 00                	mov    (%eax),%al
  8015a9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b2:	01 c2                	add    %eax,%edx
  8015b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ba:	01 c8                	add    %ecx,%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c6:	01 c2                	add    %eax,%edx
  8015c8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015cb:	88 02                	mov    %al,(%edx)
		start++ ;
  8015cd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015d0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015d9:	7c c4                	jl     80159f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015db:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e1:	01 d0                	add    %edx,%eax
  8015e3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015e6:	90                   	nop
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015ef:	ff 75 08             	pushl  0x8(%ebp)
  8015f2:	e8 54 fa ff ff       	call   80104b <strlen>
  8015f7:	83 c4 04             	add    $0x4,%esp
  8015fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015fd:	ff 75 0c             	pushl  0xc(%ebp)
  801600:	e8 46 fa ff ff       	call   80104b <strlen>
  801605:	83 c4 04             	add    $0x4,%esp
  801608:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80160b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801612:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801619:	eb 17                	jmp    801632 <strcconcat+0x49>
		final[s] = str1[s] ;
  80161b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161e:	8b 45 10             	mov    0x10(%ebp),%eax
  801621:	01 c2                	add    %eax,%edx
  801623:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	01 c8                	add    %ecx,%eax
  80162b:	8a 00                	mov    (%eax),%al
  80162d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80162f:	ff 45 fc             	incl   -0x4(%ebp)
  801632:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801635:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801638:	7c e1                	jl     80161b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80163a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801641:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801648:	eb 1f                	jmp    801669 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80164a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164d:	8d 50 01             	lea    0x1(%eax),%edx
  801650:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801653:	89 c2                	mov    %eax,%edx
  801655:	8b 45 10             	mov    0x10(%ebp),%eax
  801658:	01 c2                	add    %eax,%edx
  80165a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80165d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801660:	01 c8                	add    %ecx,%eax
  801662:	8a 00                	mov    (%eax),%al
  801664:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801666:	ff 45 f8             	incl   -0x8(%ebp)
  801669:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80166c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80166f:	7c d9                	jl     80164a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801671:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801674:	8b 45 10             	mov    0x10(%ebp),%eax
  801677:	01 d0                	add    %edx,%eax
  801679:	c6 00 00             	movb   $0x0,(%eax)
}
  80167c:	90                   	nop
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801682:	8b 45 14             	mov    0x14(%ebp),%eax
  801685:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80168b:	8b 45 14             	mov    0x14(%ebp),%eax
  80168e:	8b 00                	mov    (%eax),%eax
  801690:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801697:	8b 45 10             	mov    0x10(%ebp),%eax
  80169a:	01 d0                	add    %edx,%eax
  80169c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016a2:	eb 0c                	jmp    8016b0 <strsplit+0x31>
			*string++ = 0;
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	8d 50 01             	lea    0x1(%eax),%edx
  8016aa:	89 55 08             	mov    %edx,0x8(%ebp)
  8016ad:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	8a 00                	mov    (%eax),%al
  8016b5:	84 c0                	test   %al,%al
  8016b7:	74 18                	je     8016d1 <strsplit+0x52>
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	0f be c0             	movsbl %al,%eax
  8016c1:	50                   	push   %eax
  8016c2:	ff 75 0c             	pushl  0xc(%ebp)
  8016c5:	e8 13 fb ff ff       	call   8011dd <strchr>
  8016ca:	83 c4 08             	add    $0x8,%esp
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	75 d3                	jne    8016a4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	84 c0                	test   %al,%al
  8016d8:	74 5a                	je     801734 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016da:	8b 45 14             	mov    0x14(%ebp),%eax
  8016dd:	8b 00                	mov    (%eax),%eax
  8016df:	83 f8 0f             	cmp    $0xf,%eax
  8016e2:	75 07                	jne    8016eb <strsplit+0x6c>
		{
			return 0;
  8016e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e9:	eb 66                	jmp    801751 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ee:	8b 00                	mov    (%eax),%eax
  8016f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8016f3:	8b 55 14             	mov    0x14(%ebp),%edx
  8016f6:	89 0a                	mov    %ecx,(%edx)
  8016f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801702:	01 c2                	add    %eax,%edx
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801709:	eb 03                	jmp    80170e <strsplit+0x8f>
			string++;
  80170b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	84 c0                	test   %al,%al
  801715:	74 8b                	je     8016a2 <strsplit+0x23>
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	0f be c0             	movsbl %al,%eax
  80171f:	50                   	push   %eax
  801720:	ff 75 0c             	pushl  0xc(%ebp)
  801723:	e8 b5 fa ff ff       	call   8011dd <strchr>
  801728:	83 c4 08             	add    $0x8,%esp
  80172b:	85 c0                	test   %eax,%eax
  80172d:	74 dc                	je     80170b <strsplit+0x8c>
			string++;
	}
  80172f:	e9 6e ff ff ff       	jmp    8016a2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801734:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801735:	8b 45 14             	mov    0x14(%ebp),%eax
  801738:	8b 00                	mov    (%eax),%eax
  80173a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801741:	8b 45 10             	mov    0x10(%ebp),%eax
  801744:	01 d0                	add    %edx,%eax
  801746:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80174c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  801759:	a1 28 30 80 00       	mov    0x803028,%eax
  80175e:	85 c0                	test   %eax,%eax
  801760:	75 33                	jne    801795 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801762:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  801769:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  80176c:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  801773:	00 00 a0 
		spaces[0].pages = numPages;
  801776:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  80177d:	00 02 00 
		spaces[0].isFree = 1;
  801780:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  801787:	00 00 00 
		arraySize++;
  80178a:	a1 28 30 80 00       	mov    0x803028,%eax
  80178f:	40                   	inc    %eax
  801790:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  801795:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  80179c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  8017a3:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8017aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b0:	01 d0                	add    %edx,%eax
  8017b2:	48                   	dec    %eax
  8017b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017be:	f7 75 e8             	divl   -0x18(%ebp)
  8017c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017c4:	29 d0                	sub    %edx,%eax
  8017c6:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	c1 e8 0c             	shr    $0xc,%eax
  8017cf:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  8017d2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8017d9:	eb 57                	jmp    801832 <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  8017db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017de:	c1 e0 04             	shl    $0x4,%eax
  8017e1:	05 2c 31 80 00       	add    $0x80312c,%eax
  8017e6:	8b 00                	mov    (%eax),%eax
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	74 42                	je     80182e <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  8017ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ef:	c1 e0 04             	shl    $0x4,%eax
  8017f2:	05 28 31 80 00       	add    $0x803128,%eax
  8017f7:	8b 00                	mov    (%eax),%eax
  8017f9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8017fc:	7c 31                	jl     80182f <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  8017fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801801:	c1 e0 04             	shl    $0x4,%eax
  801804:	05 28 31 80 00       	add    $0x803128,%eax
  801809:	8b 00                	mov    (%eax),%eax
  80180b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80180e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801811:	7d 1c                	jge    80182f <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  801813:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801816:	c1 e0 04             	shl    $0x4,%eax
  801819:	05 28 31 80 00       	add    $0x803128,%eax
  80181e:	8b 00                	mov    (%eax),%eax
  801820:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801823:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  801826:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801829:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80182c:	eb 01                	jmp    80182f <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  80182e:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  80182f:	ff 45 ec             	incl   -0x14(%ebp)
  801832:	a1 28 30 80 00       	mov    0x803028,%eax
  801837:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80183a:	7c 9f                	jl     8017db <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  80183c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801840:	75 0a                	jne    80184c <malloc+0xf9>
	{
		return NULL;
  801842:	b8 00 00 00 00       	mov    $0x0,%eax
  801847:	e9 34 01 00 00       	jmp    801980 <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  80184c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184f:	c1 e0 04             	shl    $0x4,%eax
  801852:	05 28 31 80 00       	add    $0x803128,%eax
  801857:	8b 00                	mov    (%eax),%eax
  801859:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80185c:	75 38                	jne    801896 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  80185e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801861:	c1 e0 04             	shl    $0x4,%eax
  801864:	05 2c 31 80 00       	add    $0x80312c,%eax
  801869:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  80186f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801872:	c1 e0 0c             	shl    $0xc,%eax
  801875:	89 c2                	mov    %eax,%edx
  801877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187a:	c1 e0 04             	shl    $0x4,%eax
  80187d:	05 20 31 80 00       	add    $0x803120,%eax
  801882:	8b 00                	mov    (%eax),%eax
  801884:	83 ec 08             	sub    $0x8,%esp
  801887:	52                   	push   %edx
  801888:	50                   	push   %eax
  801889:	e8 01 06 00 00       	call   801e8f <sys_allocateMem>
  80188e:	83 c4 10             	add    $0x10,%esp
  801891:	e9 dd 00 00 00       	jmp    801973 <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  801896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801899:	c1 e0 04             	shl    $0x4,%eax
  80189c:	05 20 31 80 00       	add    $0x803120,%eax
  8018a1:	8b 00                	mov    (%eax),%eax
  8018a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018a6:	c1 e2 0c             	shl    $0xc,%edx
  8018a9:	01 d0                	add    %edx,%eax
  8018ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  8018ae:	a1 28 30 80 00       	mov    0x803028,%eax
  8018b3:	c1 e0 04             	shl    $0x4,%eax
  8018b6:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  8018bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018bf:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  8018c1:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8018c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ca:	c1 e0 04             	shl    $0x4,%eax
  8018cd:	05 24 31 80 00       	add    $0x803124,%eax
  8018d2:	8b 00                	mov    (%eax),%eax
  8018d4:	c1 e2 04             	shl    $0x4,%edx
  8018d7:	81 c2 24 31 80 00    	add    $0x803124,%edx
  8018dd:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  8018df:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8018e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e8:	c1 e0 04             	shl    $0x4,%eax
  8018eb:	05 28 31 80 00       	add    $0x803128,%eax
  8018f0:	8b 00                	mov    (%eax),%eax
  8018f2:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8018f5:	c1 e2 04             	shl    $0x4,%edx
  8018f8:	81 c2 28 31 80 00    	add    $0x803128,%edx
  8018fe:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  801900:	a1 28 30 80 00       	mov    0x803028,%eax
  801905:	c1 e0 04             	shl    $0x4,%eax
  801908:	05 2c 31 80 00       	add    $0x80312c,%eax
  80190d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  801913:	a1 28 30 80 00       	mov    0x803028,%eax
  801918:	40                   	inc    %eax
  801919:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  80191e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801921:	c1 e0 04             	shl    $0x4,%eax
  801924:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  80192a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80192d:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  80192f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801932:	c1 e0 04             	shl    $0x4,%eax
  801935:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  80193b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80193e:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  801940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801943:	c1 e0 04             	shl    $0x4,%eax
  801946:	05 2c 31 80 00       	add    $0x80312c,%eax
  80194b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  801951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801954:	c1 e0 0c             	shl    $0xc,%eax
  801957:	89 c2                	mov    %eax,%edx
  801959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195c:	c1 e0 04             	shl    $0x4,%eax
  80195f:	05 20 31 80 00       	add    $0x803120,%eax
  801964:	8b 00                	mov    (%eax),%eax
  801966:	83 ec 08             	sub    $0x8,%esp
  801969:	52                   	push   %edx
  80196a:	50                   	push   %eax
  80196b:	e8 1f 05 00 00       	call   801e8f <sys_allocateMem>
  801970:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  801973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801976:	c1 e0 04             	shl    $0x4,%eax
  801979:	05 20 31 80 00       	add    $0x803120,%eax
  80197e:	8b 00                	mov    (%eax),%eax
	}


}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  801988:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  80198f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801996:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80199d:	eb 3f                	jmp    8019de <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  80199f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a2:	c1 e0 04             	shl    $0x4,%eax
  8019a5:	05 20 31 80 00       	add    $0x803120,%eax
  8019aa:	8b 00                	mov    (%eax),%eax
  8019ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019af:	75 2a                	jne    8019db <free+0x59>
		{
			index=i;
  8019b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  8019b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ba:	c1 e0 04             	shl    $0x4,%eax
  8019bd:	05 28 31 80 00       	add    $0x803128,%eax
  8019c2:	8b 00                	mov    (%eax),%eax
  8019c4:	c1 e0 0c             	shl    $0xc,%eax
  8019c7:	89 c2                	mov    %eax,%edx
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	83 ec 08             	sub    $0x8,%esp
  8019cf:	52                   	push   %edx
  8019d0:	50                   	push   %eax
  8019d1:	e8 9d 04 00 00       	call   801e73 <sys_freeMem>
  8019d6:	83 c4 10             	add    $0x10,%esp
			break;
  8019d9:	eb 0d                	jmp    8019e8 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  8019db:	ff 45 ec             	incl   -0x14(%ebp)
  8019de:	a1 28 30 80 00       	mov    0x803028,%eax
  8019e3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8019e6:	7c b7                	jl     80199f <free+0x1d>
			break;
		}

	}

	if(index == -1)
  8019e8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8019ec:	75 17                	jne    801a05 <free+0x83>
	{
		panic("Error");
  8019ee:	83 ec 04             	sub    $0x4,%esp
  8019f1:	68 10 2d 80 00       	push   $0x802d10
  8019f6:	68 81 00 00 00       	push   $0x81
  8019fb:	68 16 2d 80 00       	push   $0x802d16
  801a00:	e8 22 ed ff ff       	call   800727 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  801a05:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a0c:	e9 cc 00 00 00       	jmp    801add <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  801a11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a14:	c1 e0 04             	shl    $0x4,%eax
  801a17:	05 2c 31 80 00       	add    $0x80312c,%eax
  801a1c:	8b 00                	mov    (%eax),%eax
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	0f 84 b3 00 00 00    	je     801ad9 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  801a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a29:	c1 e0 04             	shl    $0x4,%eax
  801a2c:	05 20 31 80 00       	add    $0x803120,%eax
  801a31:	8b 10                	mov    (%eax),%edx
  801a33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a36:	c1 e0 04             	shl    $0x4,%eax
  801a39:	05 24 31 80 00       	add    $0x803124,%eax
  801a3e:	8b 00                	mov    (%eax),%eax
  801a40:	39 c2                	cmp    %eax,%edx
  801a42:	0f 85 92 00 00 00    	jne    801ada <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  801a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4b:	c1 e0 04             	shl    $0x4,%eax
  801a4e:	05 24 31 80 00       	add    $0x803124,%eax
  801a53:	8b 00                	mov    (%eax),%eax
  801a55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a58:	c1 e2 04             	shl    $0x4,%edx
  801a5b:	81 c2 24 31 80 00    	add    $0x803124,%edx
  801a61:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801a63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a66:	c1 e0 04             	shl    $0x4,%eax
  801a69:	05 28 31 80 00       	add    $0x803128,%eax
  801a6e:	8b 10                	mov    (%eax),%edx
  801a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a73:	c1 e0 04             	shl    $0x4,%eax
  801a76:	05 28 31 80 00       	add    $0x803128,%eax
  801a7b:	8b 00                	mov    (%eax),%eax
  801a7d:	01 c2                	add    %eax,%edx
  801a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a82:	c1 e0 04             	shl    $0x4,%eax
  801a85:	05 28 31 80 00       	add    $0x803128,%eax
  801a8a:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8f:	c1 e0 04             	shl    $0x4,%eax
  801a92:	05 20 31 80 00       	add    $0x803120,%eax
  801a97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa0:	c1 e0 04             	shl    $0x4,%eax
  801aa3:	05 24 31 80 00       	add    $0x803124,%eax
  801aa8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab1:	c1 e0 04             	shl    $0x4,%eax
  801ab4:	05 28 31 80 00       	add    $0x803128,%eax
  801ab9:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac2:	c1 e0 04             	shl    $0x4,%eax
  801ac5:	05 2c 31 80 00       	add    $0x80312c,%eax
  801aca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801ad0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801ad7:	eb 12                	jmp    801aeb <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801ad9:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801ada:	ff 45 e8             	incl   -0x18(%ebp)
  801add:	a1 28 30 80 00       	mov    0x803028,%eax
  801ae2:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801ae5:	0f 8c 26 ff ff ff    	jl     801a11 <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801aeb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801af2:	e9 cc 00 00 00       	jmp    801bc3 <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  801af7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801afa:	c1 e0 04             	shl    $0x4,%eax
  801afd:	05 2c 31 80 00       	add    $0x80312c,%eax
  801b02:	8b 00                	mov    (%eax),%eax
  801b04:	85 c0                	test   %eax,%eax
  801b06:	0f 84 b3 00 00 00    	je     801bbf <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  801b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0f:	c1 e0 04             	shl    $0x4,%eax
  801b12:	05 24 31 80 00       	add    $0x803124,%eax
  801b17:	8b 10                	mov    (%eax),%edx
  801b19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b1c:	c1 e0 04             	shl    $0x4,%eax
  801b1f:	05 20 31 80 00       	add    $0x803120,%eax
  801b24:	8b 00                	mov    (%eax),%eax
  801b26:	39 c2                	cmp    %eax,%edx
  801b28:	0f 85 92 00 00 00    	jne    801bc0 <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  801b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b31:	c1 e0 04             	shl    $0x4,%eax
  801b34:	05 20 31 80 00       	add    $0x803120,%eax
  801b39:	8b 00                	mov    (%eax),%eax
  801b3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b3e:	c1 e2 04             	shl    $0x4,%edx
  801b41:	81 c2 20 31 80 00    	add    $0x803120,%edx
  801b47:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801b49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b4c:	c1 e0 04             	shl    $0x4,%eax
  801b4f:	05 28 31 80 00       	add    $0x803128,%eax
  801b54:	8b 10                	mov    (%eax),%edx
  801b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b59:	c1 e0 04             	shl    $0x4,%eax
  801b5c:	05 28 31 80 00       	add    $0x803128,%eax
  801b61:	8b 00                	mov    (%eax),%eax
  801b63:	01 c2                	add    %eax,%edx
  801b65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b68:	c1 e0 04             	shl    $0x4,%eax
  801b6b:	05 28 31 80 00       	add    $0x803128,%eax
  801b70:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b75:	c1 e0 04             	shl    $0x4,%eax
  801b78:	05 20 31 80 00       	add    $0x803120,%eax
  801b7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b86:	c1 e0 04             	shl    $0x4,%eax
  801b89:	05 24 31 80 00       	add    $0x803124,%eax
  801b8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b97:	c1 e0 04             	shl    $0x4,%eax
  801b9a:	05 28 31 80 00       	add    $0x803128,%eax
  801b9f:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba8:	c1 e0 04             	shl    $0x4,%eax
  801bab:	05 2c 31 80 00       	add    $0x80312c,%eax
  801bb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801bb6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801bbd:	eb 12                	jmp    801bd1 <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801bbf:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801bc0:	ff 45 e4             	incl   -0x1c(%ebp)
  801bc3:	a1 28 30 80 00       	mov    0x803028,%eax
  801bc8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bcb:	0f 8c 26 ff ff ff    	jl     801af7 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  801bd1:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801bd5:	75 11                	jne    801be8 <free+0x266>
	{
		spaces[index].isFree = 1;
  801bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bda:	c1 e0 04             	shl    $0x4,%eax
  801bdd:	05 2c 31 80 00       	add    $0x80312c,%eax
  801be2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  801be8:	90                   	nop
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	83 ec 18             	sub    $0x18,%esp
  801bf1:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf4:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801bf7:	83 ec 04             	sub    $0x4,%esp
  801bfa:	68 24 2d 80 00       	push   $0x802d24
  801bff:	68 b9 00 00 00       	push   $0xb9
  801c04:	68 16 2d 80 00       	push   $0x802d16
  801c09:	e8 19 eb ff ff       	call   800727 <_panic>

00801c0e <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c14:	83 ec 04             	sub    $0x4,%esp
  801c17:	68 24 2d 80 00       	push   $0x802d24
  801c1c:	68 bf 00 00 00       	push   $0xbf
  801c21:	68 16 2d 80 00       	push   $0x802d16
  801c26:	e8 fc ea ff ff       	call   800727 <_panic>

00801c2b <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c31:	83 ec 04             	sub    $0x4,%esp
  801c34:	68 24 2d 80 00       	push   $0x802d24
  801c39:	68 c5 00 00 00       	push   $0xc5
  801c3e:	68 16 2d 80 00       	push   $0x802d16
  801c43:	e8 df ea ff ff       	call   800727 <_panic>

00801c48 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c4e:	83 ec 04             	sub    $0x4,%esp
  801c51:	68 24 2d 80 00       	push   $0x802d24
  801c56:	68 ca 00 00 00       	push   $0xca
  801c5b:	68 16 2d 80 00       	push   $0x802d16
  801c60:	e8 c2 ea ff ff       	call   800727 <_panic>

00801c65 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c6b:	83 ec 04             	sub    $0x4,%esp
  801c6e:	68 24 2d 80 00       	push   $0x802d24
  801c73:	68 d0 00 00 00       	push   $0xd0
  801c78:	68 16 2d 80 00       	push   $0x802d16
  801c7d:	e8 a5 ea ff ff       	call   800727 <_panic>

00801c82 <shrink>:
}
void shrink(uint32 newSize)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c88:	83 ec 04             	sub    $0x4,%esp
  801c8b:	68 24 2d 80 00       	push   $0x802d24
  801c90:	68 d4 00 00 00       	push   $0xd4
  801c95:	68 16 2d 80 00       	push   $0x802d16
  801c9a:	e8 88 ea ff ff       	call   800727 <_panic>

00801c9f <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ca5:	83 ec 04             	sub    $0x4,%esp
  801ca8:	68 24 2d 80 00       	push   $0x802d24
  801cad:	68 d9 00 00 00       	push   $0xd9
  801cb2:	68 16 2d 80 00       	push   $0x802d16
  801cb7:	e8 6b ea ff ff       	call   800727 <_panic>

00801cbc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	57                   	push   %edi
  801cc0:	56                   	push   %esi
  801cc1:	53                   	push   %ebx
  801cc2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd1:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cd4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cd7:	cd 30                	int    $0x30
  801cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cdf:	83 c4 10             	add    $0x10,%esp
  801ce2:	5b                   	pop    %ebx
  801ce3:	5e                   	pop    %esi
  801ce4:	5f                   	pop    %edi
  801ce5:	5d                   	pop    %ebp
  801ce6:	c3                   	ret    

00801ce7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 04             	sub    $0x4,%esp
  801ced:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cf3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	52                   	push   %edx
  801cff:	ff 75 0c             	pushl  0xc(%ebp)
  801d02:	50                   	push   %eax
  801d03:	6a 00                	push   $0x0
  801d05:	e8 b2 ff ff ff       	call   801cbc <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
}
  801d0d:	90                   	nop
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 01                	push   $0x1
  801d1f:	e8 98 ff ff ff       	call   801cbc <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	50                   	push   %eax
  801d38:	6a 05                	push   $0x5
  801d3a:	e8 7d ff ff ff       	call   801cbc <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 02                	push   $0x2
  801d53:	e8 64 ff ff ff       	call   801cbc <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 03                	push   $0x3
  801d6c:	e8 4b ff ff ff       	call   801cbc <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 04                	push   $0x4
  801d85:	e8 32 ff ff ff       	call   801cbc <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_env_exit>:


void sys_env_exit(void)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 06                	push   $0x6
  801d9e:	e8 19 ff ff ff       	call   801cbc <syscall>
  801da3:	83 c4 18             	add    $0x18,%esp
}
  801da6:	90                   	nop
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801dac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	52                   	push   %edx
  801db9:	50                   	push   %eax
  801dba:	6a 07                	push   $0x7
  801dbc:	e8 fb fe ff ff       	call   801cbc <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	56                   	push   %esi
  801dca:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801dcb:	8b 75 18             	mov    0x18(%ebp),%esi
  801dce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dd1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dda:	56                   	push   %esi
  801ddb:	53                   	push   %ebx
  801ddc:	51                   	push   %ecx
  801ddd:	52                   	push   %edx
  801dde:	50                   	push   %eax
  801ddf:	6a 08                	push   $0x8
  801de1:	e8 d6 fe ff ff       	call   801cbc <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dec:	5b                   	pop    %ebx
  801ded:	5e                   	pop    %esi
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    

00801df0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801df3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df6:	8b 45 08             	mov    0x8(%ebp),%eax
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	52                   	push   %edx
  801e00:	50                   	push   %eax
  801e01:	6a 09                	push   $0x9
  801e03:	e8 b4 fe ff ff       	call   801cbc <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	ff 75 0c             	pushl  0xc(%ebp)
  801e19:	ff 75 08             	pushl  0x8(%ebp)
  801e1c:	6a 0a                	push   $0xa
  801e1e:	e8 99 fe ff ff       	call   801cbc <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 0b                	push   $0xb
  801e37:	e8 80 fe ff ff       	call   801cbc <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 0c                	push   $0xc
  801e50:	e8 67 fe ff ff       	call   801cbc <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 0d                	push   $0xd
  801e69:	e8 4e fe ff ff       	call   801cbc <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	ff 75 0c             	pushl  0xc(%ebp)
  801e7f:	ff 75 08             	pushl  0x8(%ebp)
  801e82:	6a 11                	push   $0x11
  801e84:	e8 33 fe ff ff       	call   801cbc <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
	return;
  801e8c:	90                   	nop
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	ff 75 0c             	pushl  0xc(%ebp)
  801e9b:	ff 75 08             	pushl  0x8(%ebp)
  801e9e:	6a 12                	push   $0x12
  801ea0:	e8 17 fe ff ff       	call   801cbc <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea8:	90                   	nop
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 0e                	push   $0xe
  801eba:	e8 fd fd ff ff       	call   801cbc <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
}
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	ff 75 08             	pushl  0x8(%ebp)
  801ed2:	6a 0f                	push   $0xf
  801ed4:	e8 e3 fd ff ff       	call   801cbc <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 10                	push   $0x10
  801eed:	e8 ca fd ff ff       	call   801cbc <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
}
  801ef5:	90                   	nop
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 14                	push   $0x14
  801f07:	e8 b0 fd ff ff       	call   801cbc <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	90                   	nop
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 15                	push   $0x15
  801f21:	e8 96 fd ff ff       	call   801cbc <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
}
  801f29:	90                   	nop
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_cputc>:


void
sys_cputc(const char c)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 04             	sub    $0x4,%esp
  801f32:	8b 45 08             	mov    0x8(%ebp),%eax
  801f35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f38:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	50                   	push   %eax
  801f45:	6a 16                	push   $0x16
  801f47:	e8 70 fd ff ff       	call   801cbc <syscall>
  801f4c:	83 c4 18             	add    $0x18,%esp
}
  801f4f:	90                   	nop
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 17                	push   $0x17
  801f61:	e8 56 fd ff ff       	call   801cbc <syscall>
  801f66:	83 c4 18             	add    $0x18,%esp
}
  801f69:	90                   	nop
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	ff 75 0c             	pushl  0xc(%ebp)
  801f7b:	50                   	push   %eax
  801f7c:	6a 18                	push   $0x18
  801f7e:	e8 39 fd ff ff       	call   801cbc <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	52                   	push   %edx
  801f98:	50                   	push   %eax
  801f99:	6a 1b                	push   $0x1b
  801f9b:	e8 1c fd ff ff       	call   801cbc <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	52                   	push   %edx
  801fb5:	50                   	push   %eax
  801fb6:	6a 19                	push   $0x19
  801fb8:	e8 ff fc ff ff       	call   801cbc <syscall>
  801fbd:	83 c4 18             	add    $0x18,%esp
}
  801fc0:	90                   	nop
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	52                   	push   %edx
  801fd3:	50                   	push   %eax
  801fd4:	6a 1a                	push   $0x1a
  801fd6:	e8 e1 fc ff ff       	call   801cbc <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
}
  801fde:	90                   	nop
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 04             	sub    $0x4,%esp
  801fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  801fea:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fed:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ff0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	6a 00                	push   $0x0
  801ff9:	51                   	push   %ecx
  801ffa:	52                   	push   %edx
  801ffb:	ff 75 0c             	pushl  0xc(%ebp)
  801ffe:	50                   	push   %eax
  801fff:	6a 1c                	push   $0x1c
  802001:	e8 b6 fc ff ff       	call   801cbc <syscall>
  802006:	83 c4 18             	add    $0x18,%esp
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80200e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	52                   	push   %edx
  80201b:	50                   	push   %eax
  80201c:	6a 1d                	push   $0x1d
  80201e:	e8 99 fc ff ff       	call   801cbc <syscall>
  802023:	83 c4 18             	add    $0x18,%esp
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80202b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	51                   	push   %ecx
  802039:	52                   	push   %edx
  80203a:	50                   	push   %eax
  80203b:	6a 1e                	push   $0x1e
  80203d:	e8 7a fc ff ff       	call   801cbc <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80204a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	52                   	push   %edx
  802057:	50                   	push   %eax
  802058:	6a 1f                	push   $0x1f
  80205a:	e8 5d fc ff ff       	call   801cbc <syscall>
  80205f:	83 c4 18             	add    $0x18,%esp
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 20                	push   $0x20
  802073:	e8 44 fc ff ff       	call   801cbc <syscall>
  802078:	83 c4 18             	add    $0x18,%esp
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	6a 00                	push   $0x0
  802085:	ff 75 14             	pushl  0x14(%ebp)
  802088:	ff 75 10             	pushl  0x10(%ebp)
  80208b:	ff 75 0c             	pushl  0xc(%ebp)
  80208e:	50                   	push   %eax
  80208f:	6a 21                	push   $0x21
  802091:	e8 26 fc ff ff       	call   801cbc <syscall>
  802096:	83 c4 18             	add    $0x18,%esp
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80209e:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	50                   	push   %eax
  8020aa:	6a 22                	push   $0x22
  8020ac:	e8 0b fc ff ff       	call   801cbc <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
}
  8020b4:	90                   	nop
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	50                   	push   %eax
  8020c6:	6a 23                	push   $0x23
  8020c8:	e8 ef fb ff ff       	call   801cbc <syscall>
  8020cd:	83 c4 18             	add    $0x18,%esp
}
  8020d0:	90                   	nop
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020d9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020dc:	8d 50 04             	lea    0x4(%eax),%edx
  8020df:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	52                   	push   %edx
  8020e9:	50                   	push   %eax
  8020ea:	6a 24                	push   $0x24
  8020ec:	e8 cb fb ff ff       	call   801cbc <syscall>
  8020f1:	83 c4 18             	add    $0x18,%esp
	return result;
  8020f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020fd:	89 01                	mov    %eax,(%ecx)
  8020ff:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	c9                   	leave  
  802106:	c2 04 00             	ret    $0x4

00802109 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	ff 75 10             	pushl  0x10(%ebp)
  802113:	ff 75 0c             	pushl  0xc(%ebp)
  802116:	ff 75 08             	pushl  0x8(%ebp)
  802119:	6a 13                	push   $0x13
  80211b:	e8 9c fb ff ff       	call   801cbc <syscall>
  802120:	83 c4 18             	add    $0x18,%esp
	return ;
  802123:	90                   	nop
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <sys_rcr2>:
uint32 sys_rcr2()
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 25                	push   $0x25
  802135:	e8 82 fb ff ff       	call   801cbc <syscall>
  80213a:	83 c4 18             	add    $0x18,%esp
}
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	83 ec 04             	sub    $0x4,%esp
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80214b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	50                   	push   %eax
  802158:	6a 26                	push   $0x26
  80215a:	e8 5d fb ff ff       	call   801cbc <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
	return ;
  802162:	90                   	nop
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <rsttst>:
void rsttst()
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 28                	push   $0x28
  802174:	e8 43 fb ff ff       	call   801cbc <syscall>
  802179:	83 c4 18             	add    $0x18,%esp
	return ;
  80217c:	90                   	nop
}
  80217d:	c9                   	leave  
  80217e:	c3                   	ret    

0080217f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
  802182:	83 ec 04             	sub    $0x4,%esp
  802185:	8b 45 14             	mov    0x14(%ebp),%eax
  802188:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80218b:	8b 55 18             	mov    0x18(%ebp),%edx
  80218e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802192:	52                   	push   %edx
  802193:	50                   	push   %eax
  802194:	ff 75 10             	pushl  0x10(%ebp)
  802197:	ff 75 0c             	pushl  0xc(%ebp)
  80219a:	ff 75 08             	pushl  0x8(%ebp)
  80219d:	6a 27                	push   $0x27
  80219f:	e8 18 fb ff ff       	call   801cbc <syscall>
  8021a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a7:	90                   	nop
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <chktst>:
void chktst(uint32 n)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	ff 75 08             	pushl  0x8(%ebp)
  8021b8:	6a 29                	push   $0x29
  8021ba:	e8 fd fa ff ff       	call   801cbc <syscall>
  8021bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c2:	90                   	nop
}
  8021c3:	c9                   	leave  
  8021c4:	c3                   	ret    

008021c5 <inctst>:

void inctst()
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 2a                	push   $0x2a
  8021d4:	e8 e3 fa ff ff       	call   801cbc <syscall>
  8021d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021dc:	90                   	nop
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <gettst>:
uint32 gettst()
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 2b                	push   $0x2b
  8021ee:	e8 c9 fa ff ff       	call   801cbc <syscall>
  8021f3:	83 c4 18             	add    $0x18,%esp
}
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
  8021fb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 2c                	push   $0x2c
  80220a:	e8 ad fa ff ff       	call   801cbc <syscall>
  80220f:	83 c4 18             	add    $0x18,%esp
  802212:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802215:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802219:	75 07                	jne    802222 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80221b:	b8 01 00 00 00       	mov    $0x1,%eax
  802220:	eb 05                	jmp    802227 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802222:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
  80222c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 2c                	push   $0x2c
  80223b:	e8 7c fa ff ff       	call   801cbc <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
  802243:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802246:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80224a:	75 07                	jne    802253 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80224c:	b8 01 00 00 00       	mov    $0x1,%eax
  802251:	eb 05                	jmp    802258 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802253:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 2c                	push   $0x2c
  80226c:	e8 4b fa ff ff       	call   801cbc <syscall>
  802271:	83 c4 18             	add    $0x18,%esp
  802274:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802277:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80227b:	75 07                	jne    802284 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80227d:	b8 01 00 00 00       	mov    $0x1,%eax
  802282:	eb 05                	jmp    802289 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802284:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 2c                	push   $0x2c
  80229d:	e8 1a fa ff ff       	call   801cbc <syscall>
  8022a2:	83 c4 18             	add    $0x18,%esp
  8022a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022a8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022ac:	75 07                	jne    8022b5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b3:	eb 05                	jmp    8022ba <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ba:	c9                   	leave  
  8022bb:	c3                   	ret    

008022bc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	ff 75 08             	pushl  0x8(%ebp)
  8022ca:	6a 2d                	push   $0x2d
  8022cc:	e8 eb f9 ff ff       	call   801cbc <syscall>
  8022d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d4:	90                   	nop
}
  8022d5:	c9                   	leave  
  8022d6:	c3                   	ret    

008022d7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
  8022da:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022db:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	6a 00                	push   $0x0
  8022e9:	53                   	push   %ebx
  8022ea:	51                   	push   %ecx
  8022eb:	52                   	push   %edx
  8022ec:	50                   	push   %eax
  8022ed:	6a 2e                	push   $0x2e
  8022ef:	e8 c8 f9 ff ff       	call   801cbc <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
}
  8022f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022fa:	c9                   	leave  
  8022fb:	c3                   	ret    

008022fc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802302:	8b 45 08             	mov    0x8(%ebp),%eax
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	52                   	push   %edx
  80230c:	50                   	push   %eax
  80230d:	6a 2f                	push   $0x2f
  80230f:	e8 a8 f9 ff ff       	call   801cbc <syscall>
  802314:	83 c4 18             	add    $0x18,%esp
}
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80231f:	8b 55 08             	mov    0x8(%ebp),%edx
  802322:	89 d0                	mov    %edx,%eax
  802324:	c1 e0 02             	shl    $0x2,%eax
  802327:	01 d0                	add    %edx,%eax
  802329:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802330:	01 d0                	add    %edx,%eax
  802332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802339:	01 d0                	add    %edx,%eax
  80233b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802342:	01 d0                	add    %edx,%eax
  802344:	c1 e0 04             	shl    $0x4,%eax
  802347:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80234a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802351:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802354:	83 ec 0c             	sub    $0xc,%esp
  802357:	50                   	push   %eax
  802358:	e8 76 fd ff ff       	call   8020d3 <sys_get_virtual_time>
  80235d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802360:	eb 41                	jmp    8023a3 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802362:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802365:	83 ec 0c             	sub    $0xc,%esp
  802368:	50                   	push   %eax
  802369:	e8 65 fd ff ff       	call   8020d3 <sys_get_virtual_time>
  80236e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802371:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802374:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802377:	29 c2                	sub    %eax,%edx
  802379:	89 d0                	mov    %edx,%eax
  80237b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80237e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802381:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802384:	89 d1                	mov    %edx,%ecx
  802386:	29 c1                	sub    %eax,%ecx
  802388:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80238b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80238e:	39 c2                	cmp    %eax,%edx
  802390:	0f 97 c0             	seta   %al
  802393:	0f b6 c0             	movzbl %al,%eax
  802396:	29 c1                	sub    %eax,%ecx
  802398:	89 c8                	mov    %ecx,%eax
  80239a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80239d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023a9:	72 b7                	jb     802362 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8023ab:	90                   	nop
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
  8023b1:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8023b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8023bb:	eb 03                	jmp    8023c0 <busy_wait+0x12>
  8023bd:	ff 45 fc             	incl   -0x4(%ebp)
  8023c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023c6:	72 f5                	jb     8023bd <busy_wait+0xf>
	return i;
  8023c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    
  8023cd:	66 90                	xchg   %ax,%ax
  8023cf:	90                   	nop

008023d0 <__udivdi3>:
  8023d0:	55                   	push   %ebp
  8023d1:	57                   	push   %edi
  8023d2:	56                   	push   %esi
  8023d3:	53                   	push   %ebx
  8023d4:	83 ec 1c             	sub    $0x1c,%esp
  8023d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8023db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8023df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023e7:	89 ca                	mov    %ecx,%edx
  8023e9:	89 f8                	mov    %edi,%eax
  8023eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8023ef:	85 f6                	test   %esi,%esi
  8023f1:	75 2d                	jne    802420 <__udivdi3+0x50>
  8023f3:	39 cf                	cmp    %ecx,%edi
  8023f5:	77 65                	ja     80245c <__udivdi3+0x8c>
  8023f7:	89 fd                	mov    %edi,%ebp
  8023f9:	85 ff                	test   %edi,%edi
  8023fb:	75 0b                	jne    802408 <__udivdi3+0x38>
  8023fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802402:	31 d2                	xor    %edx,%edx
  802404:	f7 f7                	div    %edi
  802406:	89 c5                	mov    %eax,%ebp
  802408:	31 d2                	xor    %edx,%edx
  80240a:	89 c8                	mov    %ecx,%eax
  80240c:	f7 f5                	div    %ebp
  80240e:	89 c1                	mov    %eax,%ecx
  802410:	89 d8                	mov    %ebx,%eax
  802412:	f7 f5                	div    %ebp
  802414:	89 cf                	mov    %ecx,%edi
  802416:	89 fa                	mov    %edi,%edx
  802418:	83 c4 1c             	add    $0x1c,%esp
  80241b:	5b                   	pop    %ebx
  80241c:	5e                   	pop    %esi
  80241d:	5f                   	pop    %edi
  80241e:	5d                   	pop    %ebp
  80241f:	c3                   	ret    
  802420:	39 ce                	cmp    %ecx,%esi
  802422:	77 28                	ja     80244c <__udivdi3+0x7c>
  802424:	0f bd fe             	bsr    %esi,%edi
  802427:	83 f7 1f             	xor    $0x1f,%edi
  80242a:	75 40                	jne    80246c <__udivdi3+0x9c>
  80242c:	39 ce                	cmp    %ecx,%esi
  80242e:	72 0a                	jb     80243a <__udivdi3+0x6a>
  802430:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802434:	0f 87 9e 00 00 00    	ja     8024d8 <__udivdi3+0x108>
  80243a:	b8 01 00 00 00       	mov    $0x1,%eax
  80243f:	89 fa                	mov    %edi,%edx
  802441:	83 c4 1c             	add    $0x1c,%esp
  802444:	5b                   	pop    %ebx
  802445:	5e                   	pop    %esi
  802446:	5f                   	pop    %edi
  802447:	5d                   	pop    %ebp
  802448:	c3                   	ret    
  802449:	8d 76 00             	lea    0x0(%esi),%esi
  80244c:	31 ff                	xor    %edi,%edi
  80244e:	31 c0                	xor    %eax,%eax
  802450:	89 fa                	mov    %edi,%edx
  802452:	83 c4 1c             	add    $0x1c,%esp
  802455:	5b                   	pop    %ebx
  802456:	5e                   	pop    %esi
  802457:	5f                   	pop    %edi
  802458:	5d                   	pop    %ebp
  802459:	c3                   	ret    
  80245a:	66 90                	xchg   %ax,%ax
  80245c:	89 d8                	mov    %ebx,%eax
  80245e:	f7 f7                	div    %edi
  802460:	31 ff                	xor    %edi,%edi
  802462:	89 fa                	mov    %edi,%edx
  802464:	83 c4 1c             	add    $0x1c,%esp
  802467:	5b                   	pop    %ebx
  802468:	5e                   	pop    %esi
  802469:	5f                   	pop    %edi
  80246a:	5d                   	pop    %ebp
  80246b:	c3                   	ret    
  80246c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802471:	89 eb                	mov    %ebp,%ebx
  802473:	29 fb                	sub    %edi,%ebx
  802475:	89 f9                	mov    %edi,%ecx
  802477:	d3 e6                	shl    %cl,%esi
  802479:	89 c5                	mov    %eax,%ebp
  80247b:	88 d9                	mov    %bl,%cl
  80247d:	d3 ed                	shr    %cl,%ebp
  80247f:	89 e9                	mov    %ebp,%ecx
  802481:	09 f1                	or     %esi,%ecx
  802483:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802487:	89 f9                	mov    %edi,%ecx
  802489:	d3 e0                	shl    %cl,%eax
  80248b:	89 c5                	mov    %eax,%ebp
  80248d:	89 d6                	mov    %edx,%esi
  80248f:	88 d9                	mov    %bl,%cl
  802491:	d3 ee                	shr    %cl,%esi
  802493:	89 f9                	mov    %edi,%ecx
  802495:	d3 e2                	shl    %cl,%edx
  802497:	8b 44 24 08          	mov    0x8(%esp),%eax
  80249b:	88 d9                	mov    %bl,%cl
  80249d:	d3 e8                	shr    %cl,%eax
  80249f:	09 c2                	or     %eax,%edx
  8024a1:	89 d0                	mov    %edx,%eax
  8024a3:	89 f2                	mov    %esi,%edx
  8024a5:	f7 74 24 0c          	divl   0xc(%esp)
  8024a9:	89 d6                	mov    %edx,%esi
  8024ab:	89 c3                	mov    %eax,%ebx
  8024ad:	f7 e5                	mul    %ebp
  8024af:	39 d6                	cmp    %edx,%esi
  8024b1:	72 19                	jb     8024cc <__udivdi3+0xfc>
  8024b3:	74 0b                	je     8024c0 <__udivdi3+0xf0>
  8024b5:	89 d8                	mov    %ebx,%eax
  8024b7:	31 ff                	xor    %edi,%edi
  8024b9:	e9 58 ff ff ff       	jmp    802416 <__udivdi3+0x46>
  8024be:	66 90                	xchg   %ax,%ax
  8024c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8024c4:	89 f9                	mov    %edi,%ecx
  8024c6:	d3 e2                	shl    %cl,%edx
  8024c8:	39 c2                	cmp    %eax,%edx
  8024ca:	73 e9                	jae    8024b5 <__udivdi3+0xe5>
  8024cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024cf:	31 ff                	xor    %edi,%edi
  8024d1:	e9 40 ff ff ff       	jmp    802416 <__udivdi3+0x46>
  8024d6:	66 90                	xchg   %ax,%ax
  8024d8:	31 c0                	xor    %eax,%eax
  8024da:	e9 37 ff ff ff       	jmp    802416 <__udivdi3+0x46>
  8024df:	90                   	nop

008024e0 <__umoddi3>:
  8024e0:	55                   	push   %ebp
  8024e1:	57                   	push   %edi
  8024e2:	56                   	push   %esi
  8024e3:	53                   	push   %ebx
  8024e4:	83 ec 1c             	sub    $0x1c,%esp
  8024e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8024eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024ff:	89 f3                	mov    %esi,%ebx
  802501:	89 fa                	mov    %edi,%edx
  802503:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802507:	89 34 24             	mov    %esi,(%esp)
  80250a:	85 c0                	test   %eax,%eax
  80250c:	75 1a                	jne    802528 <__umoddi3+0x48>
  80250e:	39 f7                	cmp    %esi,%edi
  802510:	0f 86 a2 00 00 00    	jbe    8025b8 <__umoddi3+0xd8>
  802516:	89 c8                	mov    %ecx,%eax
  802518:	89 f2                	mov    %esi,%edx
  80251a:	f7 f7                	div    %edi
  80251c:	89 d0                	mov    %edx,%eax
  80251e:	31 d2                	xor    %edx,%edx
  802520:	83 c4 1c             	add    $0x1c,%esp
  802523:	5b                   	pop    %ebx
  802524:	5e                   	pop    %esi
  802525:	5f                   	pop    %edi
  802526:	5d                   	pop    %ebp
  802527:	c3                   	ret    
  802528:	39 f0                	cmp    %esi,%eax
  80252a:	0f 87 ac 00 00 00    	ja     8025dc <__umoddi3+0xfc>
  802530:	0f bd e8             	bsr    %eax,%ebp
  802533:	83 f5 1f             	xor    $0x1f,%ebp
  802536:	0f 84 ac 00 00 00    	je     8025e8 <__umoddi3+0x108>
  80253c:	bf 20 00 00 00       	mov    $0x20,%edi
  802541:	29 ef                	sub    %ebp,%edi
  802543:	89 fe                	mov    %edi,%esi
  802545:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802549:	89 e9                	mov    %ebp,%ecx
  80254b:	d3 e0                	shl    %cl,%eax
  80254d:	89 d7                	mov    %edx,%edi
  80254f:	89 f1                	mov    %esi,%ecx
  802551:	d3 ef                	shr    %cl,%edi
  802553:	09 c7                	or     %eax,%edi
  802555:	89 e9                	mov    %ebp,%ecx
  802557:	d3 e2                	shl    %cl,%edx
  802559:	89 14 24             	mov    %edx,(%esp)
  80255c:	89 d8                	mov    %ebx,%eax
  80255e:	d3 e0                	shl    %cl,%eax
  802560:	89 c2                	mov    %eax,%edx
  802562:	8b 44 24 08          	mov    0x8(%esp),%eax
  802566:	d3 e0                	shl    %cl,%eax
  802568:	89 44 24 04          	mov    %eax,0x4(%esp)
  80256c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802570:	89 f1                	mov    %esi,%ecx
  802572:	d3 e8                	shr    %cl,%eax
  802574:	09 d0                	or     %edx,%eax
  802576:	d3 eb                	shr    %cl,%ebx
  802578:	89 da                	mov    %ebx,%edx
  80257a:	f7 f7                	div    %edi
  80257c:	89 d3                	mov    %edx,%ebx
  80257e:	f7 24 24             	mull   (%esp)
  802581:	89 c6                	mov    %eax,%esi
  802583:	89 d1                	mov    %edx,%ecx
  802585:	39 d3                	cmp    %edx,%ebx
  802587:	0f 82 87 00 00 00    	jb     802614 <__umoddi3+0x134>
  80258d:	0f 84 91 00 00 00    	je     802624 <__umoddi3+0x144>
  802593:	8b 54 24 04          	mov    0x4(%esp),%edx
  802597:	29 f2                	sub    %esi,%edx
  802599:	19 cb                	sbb    %ecx,%ebx
  80259b:	89 d8                	mov    %ebx,%eax
  80259d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8025a1:	d3 e0                	shl    %cl,%eax
  8025a3:	89 e9                	mov    %ebp,%ecx
  8025a5:	d3 ea                	shr    %cl,%edx
  8025a7:	09 d0                	or     %edx,%eax
  8025a9:	89 e9                	mov    %ebp,%ecx
  8025ab:	d3 eb                	shr    %cl,%ebx
  8025ad:	89 da                	mov    %ebx,%edx
  8025af:	83 c4 1c             	add    $0x1c,%esp
  8025b2:	5b                   	pop    %ebx
  8025b3:	5e                   	pop    %esi
  8025b4:	5f                   	pop    %edi
  8025b5:	5d                   	pop    %ebp
  8025b6:	c3                   	ret    
  8025b7:	90                   	nop
  8025b8:	89 fd                	mov    %edi,%ebp
  8025ba:	85 ff                	test   %edi,%edi
  8025bc:	75 0b                	jne    8025c9 <__umoddi3+0xe9>
  8025be:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c3:	31 d2                	xor    %edx,%edx
  8025c5:	f7 f7                	div    %edi
  8025c7:	89 c5                	mov    %eax,%ebp
  8025c9:	89 f0                	mov    %esi,%eax
  8025cb:	31 d2                	xor    %edx,%edx
  8025cd:	f7 f5                	div    %ebp
  8025cf:	89 c8                	mov    %ecx,%eax
  8025d1:	f7 f5                	div    %ebp
  8025d3:	89 d0                	mov    %edx,%eax
  8025d5:	e9 44 ff ff ff       	jmp    80251e <__umoddi3+0x3e>
  8025da:	66 90                	xchg   %ax,%ax
  8025dc:	89 c8                	mov    %ecx,%eax
  8025de:	89 f2                	mov    %esi,%edx
  8025e0:	83 c4 1c             	add    $0x1c,%esp
  8025e3:	5b                   	pop    %ebx
  8025e4:	5e                   	pop    %esi
  8025e5:	5f                   	pop    %edi
  8025e6:	5d                   	pop    %ebp
  8025e7:	c3                   	ret    
  8025e8:	3b 04 24             	cmp    (%esp),%eax
  8025eb:	72 06                	jb     8025f3 <__umoddi3+0x113>
  8025ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8025f1:	77 0f                	ja     802602 <__umoddi3+0x122>
  8025f3:	89 f2                	mov    %esi,%edx
  8025f5:	29 f9                	sub    %edi,%ecx
  8025f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8025fb:	89 14 24             	mov    %edx,(%esp)
  8025fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802602:	8b 44 24 04          	mov    0x4(%esp),%eax
  802606:	8b 14 24             	mov    (%esp),%edx
  802609:	83 c4 1c             	add    $0x1c,%esp
  80260c:	5b                   	pop    %ebx
  80260d:	5e                   	pop    %esi
  80260e:	5f                   	pop    %edi
  80260f:	5d                   	pop    %ebp
  802610:	c3                   	ret    
  802611:	8d 76 00             	lea    0x0(%esi),%esi
  802614:	2b 04 24             	sub    (%esp),%eax
  802617:	19 fa                	sbb    %edi,%edx
  802619:	89 d1                	mov    %edx,%ecx
  80261b:	89 c6                	mov    %eax,%esi
  80261d:	e9 71 ff ff ff       	jmp    802593 <__umoddi3+0xb3>
  802622:	66 90                	xchg   %ax,%ax
  802624:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802628:	72 ea                	jb     802614 <__umoddi3+0x134>
  80262a:	89 d9                	mov    %ebx,%ecx
  80262c:	e9 62 ff ff ff       	jmp    802593 <__umoddi3+0xb3>
