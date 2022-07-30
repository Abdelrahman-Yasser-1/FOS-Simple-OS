
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 2b 07 00 00       	call   800761 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 88 00 00 00    	sub    $0x88,%esp
	/*[1] CREATE SHARED ARRAY*/
	int ret;
	char Chose;
	char Line[30];
	//2012: lock the interrupt
	sys_disable_interrupt();
  800041:	e8 37 22 00 00       	call   80227d <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 29 80 00       	push   $0x802920
  80004e:	e8 f5 0a 00 00       	call   800b48 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 29 80 00       	push   $0x802922
  80005e:	e8 e5 0a 00 00       	call   800b48 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 40 29 80 00       	push   $0x802940
  80006e:	e8 d5 0a 00 00       	call   800b48 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 29 80 00       	push   $0x802922
  80007e:	e8 c5 0a 00 00       	call   800b48 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 29 80 00       	push   $0x802920
  80008e:	e8 b5 0a 00 00       	call   800b48 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 60 29 80 00       	push   $0x802960
  8000a2:	e8 23 11 00 00       	call   8011ca <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 7f 29 80 00       	push   $0x80297f
  8000b6:	e8 b5 1e 00 00       	call   801f70 <smalloc>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 0a                	push   $0xa
  8000c6:	6a 00                	push   $0x0
  8000c8:	8d 45 82             	lea    -0x7e(%ebp),%eax
  8000cb:	50                   	push   %eax
  8000cc:	e8 5f 16 00 00       	call   801730 <strtol>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	89 c2                	mov    %eax,%edx
  8000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d9:	89 10                	mov    %edx,(%eax)
		int NumOfElements = *arrSize;
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8b 00                	mov    (%eax),%eax
  8000e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  8000e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e6:	c1 e0 02             	shl    $0x2,%eax
  8000e9:	83 ec 04             	sub    $0x4,%esp
  8000ec:	6a 00                	push   $0x0
  8000ee:	50                   	push   %eax
  8000ef:	68 87 29 80 00       	push   $0x802987
  8000f4:	e8 77 1e 00 00       	call   801f70 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 8c 29 80 00       	push   $0x80298c
  800107:	e8 3c 0a 00 00       	call   800b48 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 ae 29 80 00       	push   $0x8029ae
  800117:	e8 2c 0a 00 00       	call   800b48 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 bc 29 80 00       	push   $0x8029bc
  800127:	e8 1c 0a 00 00       	call   800b48 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 cb 29 80 00       	push   $0x8029cb
  800137:	e8 0c 0a 00 00       	call   800b48 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 db 29 80 00       	push   $0x8029db
  800147:	e8 fc 09 00 00       	call   800b48 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80014f:	e8 b5 05 00 00       	call   800709 <getchar>
  800154:	88 45 eb             	mov    %al,-0x15(%ebp)
			cputchar(Chose);
  800157:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	50                   	push   %eax
  80015f:	e8 5d 05 00 00       	call   8006c1 <cputchar>
  800164:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	6a 0a                	push   $0xa
  80016c:	e8 50 05 00 00       	call   8006c1 <cputchar>
  800171:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800174:	80 7d eb 61          	cmpb   $0x61,-0x15(%ebp)
  800178:	74 0c                	je     800186 <_main+0x14e>
  80017a:	80 7d eb 62          	cmpb   $0x62,-0x15(%ebp)
  80017e:	74 06                	je     800186 <_main+0x14e>
  800180:	80 7d eb 63          	cmpb   $0x63,-0x15(%ebp)
  800184:	75 b9                	jne    80013f <_main+0x107>

	//2012: unlock the interrupt
	sys_enable_interrupt();
  800186:	e8 0c 21 00 00       	call   802297 <sys_enable_interrupt>

	int  i ;
	switch (Chose)
  80018b:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80018f:	83 f8 62             	cmp    $0x62,%eax
  800192:	74 1d                	je     8001b1 <_main+0x179>
  800194:	83 f8 63             	cmp    $0x63,%eax
  800197:	74 2b                	je     8001c4 <_main+0x18c>
  800199:	83 f8 61             	cmp    $0x61,%eax
  80019c:	75 39                	jne    8001d7 <_main+0x19f>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	e8 9b 03 00 00       	call   800547 <InitializeAscending>
  8001ac:	83 c4 10             	add    $0x10,%esp
		break ;
  8001af:	eb 37                	jmp    8001e8 <_main+0x1b0>
	case 'b':
		InitializeDescending(Elements, NumOfElements);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 b9 03 00 00       	call   800578 <InitializeDescending>
  8001bf:	83 c4 10             	add    $0x10,%esp
		break ;
  8001c2:	eb 24                	jmp    8001e8 <_main+0x1b0>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 db 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001d2:	83 c4 10             	add    $0x10,%esp
		break ;
  8001d5:	eb 11                	jmp    8001e8 <_main+0x1b0>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	ff 75 f0             	pushl  -0x10(%ebp)
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	e8 c8 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001e5:	83 c4 10             	add    $0x10,%esp
	}

	//Create the check-finishing counter
	int numOfSlaveProgs = 3 ;
  8001e8:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	6a 04                	push   $0x4
  8001f6:	68 e4 29 80 00       	push   $0x8029e4
  8001fb:	e8 70 1d 00 00       	call   801f70 <smalloc>
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  800206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[2] RUN THE SLAVES PROGRAMS*/
	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  80020f:	a1 20 40 80 00       	mov    0x804020,%eax
  800214:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  800225:	89 c1                	mov    %eax,%ecx
  800227:	a1 20 40 80 00       	mov    0x804020,%eax
  80022c:	8b 40 74             	mov    0x74(%eax),%eax
  80022f:	52                   	push   %edx
  800230:	51                   	push   %ecx
  800231:	50                   	push   %eax
  800232:	68 f2 29 80 00       	push   $0x8029f2
  800237:	e8 c6 21 00 00       	call   802402 <sys_create_env>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800242:	a1 20 40 80 00       	mov    0x804020,%eax
  800247:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80024d:	a1 20 40 80 00       	mov    0x804020,%eax
  800252:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  800258:	89 c1                	mov    %eax,%ecx
  80025a:	a1 20 40 80 00       	mov    0x804020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	52                   	push   %edx
  800263:	51                   	push   %ecx
  800264:	50                   	push   %eax
  800265:	68 fb 29 80 00       	push   $0x8029fb
  80026a:	e8 93 21 00 00       	call   802402 <sys_create_env>
  80026f:	83 c4 10             	add    $0x10,%esp
  800272:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800275:	a1 20 40 80 00       	mov    0x804020,%eax
  80027a:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800280:	a1 20 40 80 00       	mov    0x804020,%eax
  800285:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  80028b:	89 c1                	mov    %eax,%ecx
  80028d:	a1 20 40 80 00       	mov    0x804020,%eax
  800292:	8b 40 74             	mov    0x74(%eax),%eax
  800295:	52                   	push   %edx
  800296:	51                   	push   %ecx
  800297:	50                   	push   %eax
  800298:	68 04 2a 80 00       	push   $0x802a04
  80029d:	e8 60 21 00 00       	call   802402 <sys_create_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  8002a8:	83 7d dc ef          	cmpl   $0xffffffef,-0x24(%ebp)
  8002ac:	74 0c                	je     8002ba <_main+0x282>
  8002ae:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  8002b2:	74 06                	je     8002ba <_main+0x282>
  8002b4:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  8002b8:	75 14                	jne    8002ce <_main+0x296>
		panic("NO AVAILABLE ENVs...");
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 10 2a 80 00       	push   $0x802a10
  8002c2:	6a 4b                	push   $0x4b
  8002c4:	68 25 2a 80 00       	push   $0x802a25
  8002c9:	e8 d8 05 00 00       	call   8008a6 <_panic>

	sys_run_env(envIdQuickSort);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d4:	e8 47 21 00 00       	call   802420 <sys_run_env>
  8002d9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e2:	e8 39 21 00 00       	call   802420 <sys_run_env>
  8002e7:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f0:	e8 2b 21 00 00       	call   802420 <sys_run_env>
  8002f5:	83 c4 10             	add    $0x10,%esp

	/*[3] BUSY-WAIT TILL FINISHING THEM*/
	while (*numOfFinished != numOfSlaveProgs) ;
  8002f8:	90                   	nop
  8002f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fc:	8b 00                	mov    (%eax),%eax
  8002fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800301:	75 f6                	jne    8002f9 <_main+0x2c1>

	/*[4] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  800303:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int *mergesortedArr = NULL;
  80030a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	int *mean = NULL;
  800311:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	int *var = NULL;
  800318:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	int *min = NULL;
  80031f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
	int *max = NULL;
  800326:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int *med = NULL;
  80032d:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	68 43 2a 80 00       	push   $0x802a43
  80033c:	ff 75 dc             	pushl  -0x24(%ebp)
  80033f:	e8 4f 1c 00 00       	call   801f93 <sget>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	68 52 2a 80 00       	push   $0x802a52
  800352:	ff 75 d8             	pushl  -0x28(%ebp)
  800355:	e8 39 1c 00 00       	call   801f93 <sget>
  80035a:	83 c4 10             	add    $0x10,%esp
  80035d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	68 61 2a 80 00       	push   $0x802a61
  800368:	ff 75 d4             	pushl  -0x2c(%ebp)
  80036b:	e8 23 1c 00 00       	call   801f93 <sget>
  800370:	83 c4 10             	add    $0x10,%esp
  800373:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	68 66 2a 80 00       	push   $0x802a66
  80037e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800381:	e8 0d 1c 00 00       	call   801f93 <sget>
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	68 6a 2a 80 00       	push   $0x802a6a
  800394:	ff 75 d4             	pushl  -0x2c(%ebp)
  800397:	e8 f7 1b 00 00       	call   801f93 <sget>
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	68 6e 2a 80 00       	push   $0x802a6e
  8003aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003ad:	e8 e1 1b 00 00       	call   801f93 <sget>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	68 72 2a 80 00       	push   $0x802a72
  8003c0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003c3:	e8 cb 1b 00 00       	call   801f93 <sget>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 b8             	mov    %eax,-0x48(%ebp)

	/*[5] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003d4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d7:	e8 14 01 00 00       	call   8004f0 <CheckSorted>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  8003e2:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8003e6:	75 14                	jne    8003fc <_main+0x3c4>
  8003e8:	83 ec 04             	sub    $0x4,%esp
  8003eb:	68 78 2a 80 00       	push   $0x802a78
  8003f0:	6a 66                	push   $0x66
  8003f2:	68 25 2a 80 00       	push   $0x802a25
  8003f7:	e8 aa 04 00 00       	call   8008a6 <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	ff 75 f0             	pushl  -0x10(%ebp)
  800402:	ff 75 cc             	pushl  -0x34(%ebp)
  800405:	e8 e6 00 00 00       	call   8004f0 <CheckSorted>
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  800410:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  800414:	75 14                	jne    80042a <_main+0x3f2>
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 a0 2a 80 00       	push   $0x802aa0
  80041e:	6a 68                	push   $0x68
  800420:	68 25 2a 80 00       	push   $0x802a25
  800425:	e8 7c 04 00 00       	call   8008a6 <_panic>
	int correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  80042a:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  800430:	50                   	push   %eax
  800431:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800437:	50                   	push   %eax
  800438:	ff 75 f0             	pushl  -0x10(%ebp)
  80043b:	ff 75 ec             	pushl  -0x14(%ebp)
  80043e:	e8 b6 01 00 00       	call   8005f9 <ArrayStats>
  800443:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  800446:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int last = NumOfElements-1;
  80044e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800451:	48                   	dec    %eax
  800452:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int middle = (NumOfElements-1)/2;
  800455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800458:	48                   	dec    %eax
  800459:	89 c2                	mov    %eax,%edx
  80045b:	c1 ea 1f             	shr    $0x1f,%edx
  80045e:	01 d0                	add    %edx,%eax
  800460:	d1 f8                	sar    %eax
  800462:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int correctMax = quicksortedArr[last];
  800465:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int correctMed = quicksortedArr[middle];
  800479:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//cprintf("Array is correctly sorted\n");
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);

	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  80048d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800490:	8b 10                	mov    (%eax),%edx
  800492:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800498:	39 c2                	cmp    %eax,%edx
  80049a:	75 2d                	jne    8004c9 <_main+0x491>
  80049c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80049f:	8b 10                	mov    (%eax),%edx
  8004a1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8004a7:	39 c2                	cmp    %eax,%edx
  8004a9:	75 1e                	jne    8004c9 <_main+0x491>
  8004ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  8004b3:	75 14                	jne    8004c9 <_main+0x491>
  8004b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8004bd:	75 0a                	jne    8004c9 <_main+0x491>
  8004bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	3b 45 a0             	cmp    -0x60(%ebp),%eax
  8004c7:	74 14                	je     8004dd <_main+0x4a5>
		panic("The array STATS are NOT calculated correctly") ;
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	68 c8 2a 80 00       	push   $0x802ac8
  8004d1:	6a 75                	push   $0x75
  8004d3:	68 25 2a 80 00       	push   $0x802a25
  8004d8:	e8 c9 03 00 00       	call   8008a6 <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004dd:	83 ec 0c             	sub    $0xc,%esp
  8004e0:	68 f8 2a 80 00       	push   $0x802af8
  8004e5:	e8 5e 06 00 00       	call   800b48 <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp

	return;
  8004ed:	90                   	nop
}
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8004f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8004fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800504:	eb 33                	jmp    800539 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800506:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	01 d0                	add    %edx,%eax
  800515:	8b 10                	mov    (%eax),%edx
  800517:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80051a:	40                   	inc    %eax
  80051b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	01 c8                	add    %ecx,%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	39 c2                	cmp    %eax,%edx
  80052b:	7e 09                	jle    800536 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80052d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800534:	eb 0c                	jmp    800542 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800536:	ff 45 f8             	incl   -0x8(%ebp)
  800539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053c:	48                   	dec    %eax
  80053d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800540:	7f c4                	jg     800506 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800542:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80054d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800554:	eb 17                	jmp    80056d <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800556:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	01 c2                	add    %eax,%edx
  800565:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800568:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80056a:	ff 45 fc             	incl   -0x4(%ebp)
  80056d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800570:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800573:	7c e1                	jl     800556 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800575:	90                   	nop
  800576:	c9                   	leave  
  800577:	c3                   	ret    

00800578 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800578:	55                   	push   %ebp
  800579:	89 e5                	mov    %esp,%ebp
  80057b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80057e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800585:	eb 1b                	jmp    8005a2 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800587:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80058a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	01 c2                	add    %eax,%edx
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80059c:	48                   	dec    %eax
  80059d:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80059f:	ff 45 fc             	incl   -0x4(%ebp)
  8005a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005a8:	7c dd                	jl     800587 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8005aa:	90                   	nop
  8005ab:	c9                   	leave  
  8005ac:	c3                   	ret    

008005ad <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8005b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b6:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8005bb:	f7 e9                	imul   %ecx
  8005bd:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c0:	89 d0                	mov    %edx,%eax
  8005c2:	29 c8                	sub    %ecx,%eax
  8005c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8005c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8005ce:	eb 1e                	jmp    8005ee <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8005d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8005e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005e3:	99                   	cltd   
  8005e4:	f7 7d f8             	idivl  -0x8(%ebp)
  8005e7:	89 d0                	mov    %edx,%eax
  8005e9:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8005eb:	ff 45 fc             	incl   -0x4(%ebp)
  8005ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005f4:	7c da                	jl     8005d0 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  8005f6:	90                   	nop
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	53                   	push   %ebx
  8005fd:	83 ec 10             	sub    $0x10,%esp
	int i ;
	*mean =0 ;
  800600:	8b 45 10             	mov    0x10(%ebp),%eax
  800603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800609:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800610:	eb 20                	jmp    800632 <ArrayStats+0x39>
	{
		*mean += Elements[i];
  800612:	8b 45 10             	mov    0x10(%ebp),%eax
  800615:	8b 10                	mov    (%eax),%edx
  800617:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80061a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	01 c8                	add    %ecx,%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	01 c2                	add    %eax,%edx
  80062a:	8b 45 10             	mov    0x10(%ebp),%eax
  80062d:	89 10                	mov    %edx,(%eax)

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  80062f:	ff 45 f8             	incl   -0x8(%ebp)
  800632:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800635:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800638:	7c d8                	jl     800612 <ArrayStats+0x19>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  80063a:	8b 45 10             	mov    0x10(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	99                   	cltd   
  800640:	f7 7d 0c             	idivl  0xc(%ebp)
  800643:	89 c2                	mov    %eax,%edx
  800645:	8b 45 10             	mov    0x10(%ebp),%eax
  800648:	89 10                	mov    %edx,(%eax)
	*var = 0;
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800653:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80065a:	eb 46                	jmp    8006a2 <ArrayStats+0xa9>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800664:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	01 c8                	add    %ecx,%eax
  800670:	8b 08                	mov    (%eax),%ecx
  800672:	8b 45 10             	mov    0x10(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 cb                	mov    %ecx,%ebx
  800679:	29 c3                	sub    %eax,%ebx
  80067b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80067e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	01 c8                	add    %ecx,%eax
  80068a:	8b 08                	mov    (%eax),%ecx
  80068c:	8b 45 10             	mov    0x10(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	29 c1                	sub    %eax,%ecx
  800693:	89 c8                	mov    %ecx,%eax
  800695:	0f af c3             	imul   %ebx,%eax
  800698:	01 c2                	add    %eax,%edx
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	89 10                	mov    %edx,(%eax)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  80069f:	ff 45 f8             	incl   -0x8(%ebp)
  8006a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006a8:	7c b2                	jl     80065c <ArrayStats+0x63>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
	}
	*var /= NumOfElements;
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	99                   	cltd   
  8006b0:	f7 7d 0c             	idivl  0xc(%ebp)
  8006b3:	89 c2                	mov    %eax,%edx
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	89 10                	mov    %edx,(%eax)
}
  8006ba:	90                   	nop
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	5b                   	pop    %ebx
  8006bf:	5d                   	pop    %ebp
  8006c0:	c3                   	ret    

008006c1 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006cd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006d1:	83 ec 0c             	sub    $0xc,%esp
  8006d4:	50                   	push   %eax
  8006d5:	e8 d7 1b 00 00       	call   8022b1 <sys_cputc>
  8006da:	83 c4 10             	add    $0x10,%esp
}
  8006dd:	90                   	nop
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e6:	e8 92 1b 00 00       	call   80227d <sys_disable_interrupt>
	char c = ch;
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006f1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006f5:	83 ec 0c             	sub    $0xc,%esp
  8006f8:	50                   	push   %eax
  8006f9:	e8 b3 1b 00 00       	call   8022b1 <sys_cputc>
  8006fe:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800701:	e8 91 1b 00 00       	call   802297 <sys_enable_interrupt>
}
  800706:	90                   	nop
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <getchar>:

int
getchar(void)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80070f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800716:	eb 08                	jmp    800720 <getchar+0x17>
	{
		c = sys_cgetc();
  800718:	e8 78 19 00 00       	call   802095 <sys_cgetc>
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800724:	74 f2                	je     800718 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800726:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <atomic_getchar>:

int
atomic_getchar(void)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800731:	e8 47 1b 00 00       	call   80227d <sys_disable_interrupt>
	int c=0;
  800736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80073d:	eb 08                	jmp    800747 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  80073f:	e8 51 19 00 00       	call   802095 <sys_cgetc>
  800744:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800747:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80074b:	74 f2                	je     80073f <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  80074d:	e8 45 1b 00 00       	call   802297 <sys_enable_interrupt>
	return c;
  800752:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800755:	c9                   	leave  
  800756:	c3                   	ret    

00800757 <iscons>:

int iscons(int fdnum)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80075a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800767:	e8 76 19 00 00       	call   8020e2 <sys_getenvindex>
  80076c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80076f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800772:	89 d0                	mov    %edx,%eax
  800774:	c1 e0 03             	shl    $0x3,%eax
  800777:	01 d0                	add    %edx,%eax
  800779:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800780:	01 c8                	add    %ecx,%eax
  800782:	01 c0                	add    %eax,%eax
  800784:	01 d0                	add    %edx,%eax
  800786:	01 c0                	add    %eax,%eax
  800788:	01 d0                	add    %edx,%eax
  80078a:	89 c2                	mov    %eax,%edx
  80078c:	c1 e2 05             	shl    $0x5,%edx
  80078f:	29 c2                	sub    %eax,%edx
  800791:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800798:	89 c2                	mov    %eax,%edx
  80079a:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8007a0:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8007aa:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8007b0:	84 c0                	test   %al,%al
  8007b2:	74 0f                	je     8007c3 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8007b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8007b9:	05 40 3c 01 00       	add    $0x13c40,%eax
  8007be:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007c7:	7e 0a                	jle    8007d3 <libmain+0x72>
		binaryname = argv[0];
  8007c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	ff 75 0c             	pushl  0xc(%ebp)
  8007d9:	ff 75 08             	pushl  0x8(%ebp)
  8007dc:	e8 57 f8 ff ff       	call   800038 <_main>
  8007e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8007e4:	e8 94 1a 00 00       	call   80227d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8007e9:	83 ec 0c             	sub    $0xc,%esp
  8007ec:	68 74 2b 80 00       	push   $0x802b74
  8007f1:	e8 52 03 00 00       	call   800b48 <cprintf>
  8007f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8007fe:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800804:	a1 20 40 80 00       	mov    0x804020,%eax
  800809:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80080f:	83 ec 04             	sub    $0x4,%esp
  800812:	52                   	push   %edx
  800813:	50                   	push   %eax
  800814:	68 9c 2b 80 00       	push   $0x802b9c
  800819:	e8 2a 03 00 00       	call   800b48 <cprintf>
  80081e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800821:	a1 20 40 80 00       	mov    0x804020,%eax
  800826:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80082c:	a1 20 40 80 00       	mov    0x804020,%eax
  800831:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800837:	83 ec 04             	sub    $0x4,%esp
  80083a:	52                   	push   %edx
  80083b:	50                   	push   %eax
  80083c:	68 c4 2b 80 00       	push   $0x802bc4
  800841:	e8 02 03 00 00       	call   800b48 <cprintf>
  800846:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800849:	a1 20 40 80 00       	mov    0x804020,%eax
  80084e:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800854:	83 ec 08             	sub    $0x8,%esp
  800857:	50                   	push   %eax
  800858:	68 05 2c 80 00       	push   $0x802c05
  80085d:	e8 e6 02 00 00       	call   800b48 <cprintf>
  800862:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800865:	83 ec 0c             	sub    $0xc,%esp
  800868:	68 74 2b 80 00       	push   $0x802b74
  80086d:	e8 d6 02 00 00       	call   800b48 <cprintf>
  800872:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800875:	e8 1d 1a 00 00       	call   802297 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80087a:	e8 19 00 00 00       	call   800898 <exit>
}
  80087f:	90                   	nop
  800880:	c9                   	leave  
  800881:	c3                   	ret    

00800882 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800888:	83 ec 0c             	sub    $0xc,%esp
  80088b:	6a 00                	push   $0x0
  80088d:	e8 1c 18 00 00       	call   8020ae <sys_env_destroy>
  800892:	83 c4 10             	add    $0x10,%esp
}
  800895:	90                   	nop
  800896:	c9                   	leave  
  800897:	c3                   	ret    

00800898 <exit>:

void
exit(void)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80089e:	e8 71 18 00 00       	call   802114 <sys_env_exit>
}
  8008a3:	90                   	nop
  8008a4:	c9                   	leave  
  8008a5:	c3                   	ret    

008008a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008ac:	8d 45 10             	lea    0x10(%ebp),%eax
  8008af:	83 c0 04             	add    $0x4,%eax
  8008b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008b5:	a1 18 41 80 00       	mov    0x804118,%eax
  8008ba:	85 c0                	test   %eax,%eax
  8008bc:	74 16                	je     8008d4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008be:	a1 18 41 80 00       	mov    0x804118,%eax
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	50                   	push   %eax
  8008c7:	68 1c 2c 80 00       	push   $0x802c1c
  8008cc:	e8 77 02 00 00       	call   800b48 <cprintf>
  8008d1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008d4:	a1 00 40 80 00       	mov    0x804000,%eax
  8008d9:	ff 75 0c             	pushl  0xc(%ebp)
  8008dc:	ff 75 08             	pushl  0x8(%ebp)
  8008df:	50                   	push   %eax
  8008e0:	68 21 2c 80 00       	push   $0x802c21
  8008e5:	e8 5e 02 00 00       	call   800b48 <cprintf>
  8008ea:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f6:	50                   	push   %eax
  8008f7:	e8 e1 01 00 00       	call   800add <vcprintf>
  8008fc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	6a 00                	push   $0x0
  800904:	68 3d 2c 80 00       	push   $0x802c3d
  800909:	e8 cf 01 00 00       	call   800add <vcprintf>
  80090e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800911:	e8 82 ff ff ff       	call   800898 <exit>

	// should not return here
	while (1) ;
  800916:	eb fe                	jmp    800916 <_panic+0x70>

00800918 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80091e:	a1 20 40 80 00       	mov    0x804020,%eax
  800923:	8b 50 74             	mov    0x74(%eax),%edx
  800926:	8b 45 0c             	mov    0xc(%ebp),%eax
  800929:	39 c2                	cmp    %eax,%edx
  80092b:	74 14                	je     800941 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80092d:	83 ec 04             	sub    $0x4,%esp
  800930:	68 40 2c 80 00       	push   $0x802c40
  800935:	6a 26                	push   $0x26
  800937:	68 8c 2c 80 00       	push   $0x802c8c
  80093c:	e8 65 ff ff ff       	call   8008a6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800941:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800948:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80094f:	e9 b6 00 00 00       	jmp    800a0a <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800957:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	01 d0                	add    %edx,%eax
  800963:	8b 00                	mov    (%eax),%eax
  800965:	85 c0                	test   %eax,%eax
  800967:	75 08                	jne    800971 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800969:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80096c:	e9 96 00 00 00       	jmp    800a07 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800971:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800978:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80097f:	eb 5d                	jmp    8009de <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800981:	a1 20 40 80 00       	mov    0x804020,%eax
  800986:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80098c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80098f:	c1 e2 04             	shl    $0x4,%edx
  800992:	01 d0                	add    %edx,%eax
  800994:	8a 40 04             	mov    0x4(%eax),%al
  800997:	84 c0                	test   %al,%al
  800999:	75 40                	jne    8009db <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80099b:	a1 20 40 80 00       	mov    0x804020,%eax
  8009a0:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8009a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009a9:	c1 e2 04             	shl    $0x4,%edx
  8009ac:	01 d0                	add    %edx,%eax
  8009ae:	8b 00                	mov    (%eax),%eax
  8009b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009bb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	01 c8                	add    %ecx,%eax
  8009cc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009ce:	39 c2                	cmp    %eax,%edx
  8009d0:	75 09                	jne    8009db <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8009d2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009d9:	eb 12                	jmp    8009ed <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009db:	ff 45 e8             	incl   -0x18(%ebp)
  8009de:	a1 20 40 80 00       	mov    0x804020,%eax
  8009e3:	8b 50 74             	mov    0x74(%eax),%edx
  8009e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	77 94                	ja     800981 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009f1:	75 14                	jne    800a07 <CheckWSWithoutLastIndex+0xef>
			panic(
  8009f3:	83 ec 04             	sub    $0x4,%esp
  8009f6:	68 98 2c 80 00       	push   $0x802c98
  8009fb:	6a 3a                	push   $0x3a
  8009fd:	68 8c 2c 80 00       	push   $0x802c8c
  800a02:	e8 9f fe ff ff       	call   8008a6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a07:	ff 45 f0             	incl   -0x10(%ebp)
  800a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a0d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a10:	0f 8c 3e ff ff ff    	jl     800954 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a16:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a1d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a24:	eb 20                	jmp    800a46 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a26:	a1 20 40 80 00       	mov    0x804020,%eax
  800a2b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800a31:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a34:	c1 e2 04             	shl    $0x4,%edx
  800a37:	01 d0                	add    %edx,%eax
  800a39:	8a 40 04             	mov    0x4(%eax),%al
  800a3c:	3c 01                	cmp    $0x1,%al
  800a3e:	75 03                	jne    800a43 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800a40:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a43:	ff 45 e0             	incl   -0x20(%ebp)
  800a46:	a1 20 40 80 00       	mov    0x804020,%eax
  800a4b:	8b 50 74             	mov    0x74(%eax),%edx
  800a4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a51:	39 c2                	cmp    %eax,%edx
  800a53:	77 d1                	ja     800a26 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a58:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a5b:	74 14                	je     800a71 <CheckWSWithoutLastIndex+0x159>
		panic(
  800a5d:	83 ec 04             	sub    $0x4,%esp
  800a60:	68 ec 2c 80 00       	push   $0x802cec
  800a65:	6a 44                	push   $0x44
  800a67:	68 8c 2c 80 00       	push   $0x802c8c
  800a6c:	e8 35 fe ff ff       	call   8008a6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a71:	90                   	nop
  800a72:	c9                   	leave  
  800a73:	c3                   	ret    

00800a74 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7d:	8b 00                	mov    (%eax),%eax
  800a7f:	8d 48 01             	lea    0x1(%eax),%ecx
  800a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a85:	89 0a                	mov    %ecx,(%edx)
  800a87:	8b 55 08             	mov    0x8(%ebp),%edx
  800a8a:	88 d1                	mov    %dl,%cl
  800a8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a96:	8b 00                	mov    (%eax),%eax
  800a98:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a9d:	75 2c                	jne    800acb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a9f:	a0 24 40 80 00       	mov    0x804024,%al
  800aa4:	0f b6 c0             	movzbl %al,%eax
  800aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aaa:	8b 12                	mov    (%edx),%edx
  800aac:	89 d1                	mov    %edx,%ecx
  800aae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab1:	83 c2 08             	add    $0x8,%edx
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	50                   	push   %eax
  800ab8:	51                   	push   %ecx
  800ab9:	52                   	push   %edx
  800aba:	e8 ad 15 00 00       	call   80206c <sys_cputs>
  800abf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ace:	8b 40 04             	mov    0x4(%eax),%eax
  800ad1:	8d 50 01             	lea    0x1(%eax),%edx
  800ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad7:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ada:	90                   	nop
  800adb:	c9                   	leave  
  800adc:	c3                   	ret    

00800add <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ae6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800aed:	00 00 00 
	b.cnt = 0;
  800af0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800af7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	ff 75 08             	pushl  0x8(%ebp)
  800b00:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b06:	50                   	push   %eax
  800b07:	68 74 0a 80 00       	push   $0x800a74
  800b0c:	e8 11 02 00 00       	call   800d22 <vprintfmt>
  800b11:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b14:	a0 24 40 80 00       	mov    0x804024,%al
  800b19:	0f b6 c0             	movzbl %al,%eax
  800b1c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b22:	83 ec 04             	sub    $0x4,%esp
  800b25:	50                   	push   %eax
  800b26:	52                   	push   %edx
  800b27:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b2d:	83 c0 08             	add    $0x8,%eax
  800b30:	50                   	push   %eax
  800b31:	e8 36 15 00 00       	call   80206c <sys_cputs>
  800b36:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b39:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800b40:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <cprintf>:

int cprintf(const char *fmt, ...) {
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b4e:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800b55:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b58:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	83 ec 08             	sub    $0x8,%esp
  800b61:	ff 75 f4             	pushl  -0xc(%ebp)
  800b64:	50                   	push   %eax
  800b65:	e8 73 ff ff ff       	call   800add <vcprintf>
  800b6a:	83 c4 10             	add    $0x10,%esp
  800b6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b73:	c9                   	leave  
  800b74:	c3                   	ret    

00800b75 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b7b:	e8 fd 16 00 00       	call   80227d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b80:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	83 ec 08             	sub    $0x8,%esp
  800b8c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8f:	50                   	push   %eax
  800b90:	e8 48 ff ff ff       	call   800add <vcprintf>
  800b95:	83 c4 10             	add    $0x10,%esp
  800b98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800b9b:	e8 f7 16 00 00       	call   802297 <sys_enable_interrupt>
	return cnt;
  800ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba3:	c9                   	leave  
  800ba4:	c3                   	ret    

00800ba5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	53                   	push   %ebx
  800ba9:	83 ec 14             	sub    $0x14,%esp
  800bac:	8b 45 10             	mov    0x10(%ebp),%eax
  800baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bb8:	8b 45 18             	mov    0x18(%ebp),%eax
  800bbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bc3:	77 55                	ja     800c1a <printnum+0x75>
  800bc5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bc8:	72 05                	jb     800bcf <printnum+0x2a>
  800bca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bcd:	77 4b                	ja     800c1a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bcf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bd2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bd5:	8b 45 18             	mov    0x18(%ebp),%eax
  800bd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdd:	52                   	push   %edx
  800bde:	50                   	push   %eax
  800bdf:	ff 75 f4             	pushl  -0xc(%ebp)
  800be2:	ff 75 f0             	pushl  -0x10(%ebp)
  800be5:	e8 b6 1a 00 00       	call   8026a0 <__udivdi3>
  800bea:	83 c4 10             	add    $0x10,%esp
  800bed:	83 ec 04             	sub    $0x4,%esp
  800bf0:	ff 75 20             	pushl  0x20(%ebp)
  800bf3:	53                   	push   %ebx
  800bf4:	ff 75 18             	pushl  0x18(%ebp)
  800bf7:	52                   	push   %edx
  800bf8:	50                   	push   %eax
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	ff 75 08             	pushl  0x8(%ebp)
  800bff:	e8 a1 ff ff ff       	call   800ba5 <printnum>
  800c04:	83 c4 20             	add    $0x20,%esp
  800c07:	eb 1a                	jmp    800c23 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c09:	83 ec 08             	sub    $0x8,%esp
  800c0c:	ff 75 0c             	pushl  0xc(%ebp)
  800c0f:	ff 75 20             	pushl  0x20(%ebp)
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	ff d0                	call   *%eax
  800c17:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c1a:	ff 4d 1c             	decl   0x1c(%ebp)
  800c1d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c21:	7f e6                	jg     800c09 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c23:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c31:	53                   	push   %ebx
  800c32:	51                   	push   %ecx
  800c33:	52                   	push   %edx
  800c34:	50                   	push   %eax
  800c35:	e8 76 1b 00 00       	call   8027b0 <__umoddi3>
  800c3a:	83 c4 10             	add    $0x10,%esp
  800c3d:	05 54 2f 80 00       	add    $0x802f54,%eax
  800c42:	8a 00                	mov    (%eax),%al
  800c44:	0f be c0             	movsbl %al,%eax
  800c47:	83 ec 08             	sub    $0x8,%esp
  800c4a:	ff 75 0c             	pushl  0xc(%ebp)
  800c4d:	50                   	push   %eax
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	ff d0                	call   *%eax
  800c53:	83 c4 10             	add    $0x10,%esp
}
  800c56:	90                   	nop
  800c57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c5f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c63:	7e 1c                	jle    800c81 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	8b 00                	mov    (%eax),%eax
  800c6a:	8d 50 08             	lea    0x8(%eax),%edx
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	89 10                	mov    %edx,(%eax)
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8b 00                	mov    (%eax),%eax
  800c77:	83 e8 08             	sub    $0x8,%eax
  800c7a:	8b 50 04             	mov    0x4(%eax),%edx
  800c7d:	8b 00                	mov    (%eax),%eax
  800c7f:	eb 40                	jmp    800cc1 <getuint+0x65>
	else if (lflag)
  800c81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c85:	74 1e                	je     800ca5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8b 00                	mov    (%eax),%eax
  800c8c:	8d 50 04             	lea    0x4(%eax),%edx
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	89 10                	mov    %edx,(%eax)
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	8b 00                	mov    (%eax),%eax
  800c99:	83 e8 04             	sub    $0x4,%eax
  800c9c:	8b 00                	mov    (%eax),%eax
  800c9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca3:	eb 1c                	jmp    800cc1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8b 00                	mov    (%eax),%eax
  800caa:	8d 50 04             	lea    0x4(%eax),%edx
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	89 10                	mov    %edx,(%eax)
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8b 00                	mov    (%eax),%eax
  800cb7:	83 e8 04             	sub    $0x4,%eax
  800cba:	8b 00                	mov    (%eax),%eax
  800cbc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cc6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cca:	7e 1c                	jle    800ce8 <getint+0x25>
		return va_arg(*ap, long long);
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8b 00                	mov    (%eax),%eax
  800cd1:	8d 50 08             	lea    0x8(%eax),%edx
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	89 10                	mov    %edx,(%eax)
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8b 00                	mov    (%eax),%eax
  800cde:	83 e8 08             	sub    $0x8,%eax
  800ce1:	8b 50 04             	mov    0x4(%eax),%edx
  800ce4:	8b 00                	mov    (%eax),%eax
  800ce6:	eb 38                	jmp    800d20 <getint+0x5d>
	else if (lflag)
  800ce8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cec:	74 1a                	je     800d08 <getint+0x45>
		return va_arg(*ap, long);
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8b 00                	mov    (%eax),%eax
  800cf3:	8d 50 04             	lea    0x4(%eax),%edx
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	89 10                	mov    %edx,(%eax)
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8b 00                	mov    (%eax),%eax
  800d00:	83 e8 04             	sub    $0x4,%eax
  800d03:	8b 00                	mov    (%eax),%eax
  800d05:	99                   	cltd   
  800d06:	eb 18                	jmp    800d20 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8b 00                	mov    (%eax),%eax
  800d0d:	8d 50 04             	lea    0x4(%eax),%edx
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	89 10                	mov    %edx,(%eax)
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8b 00                	mov    (%eax),%eax
  800d1a:	83 e8 04             	sub    $0x4,%eax
  800d1d:	8b 00                	mov    (%eax),%eax
  800d1f:	99                   	cltd   
}
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	56                   	push   %esi
  800d26:	53                   	push   %ebx
  800d27:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d2a:	eb 17                	jmp    800d43 <vprintfmt+0x21>
			if (ch == '\0')
  800d2c:	85 db                	test   %ebx,%ebx
  800d2e:	0f 84 af 03 00 00    	je     8010e3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d34:	83 ec 08             	sub    $0x8,%esp
  800d37:	ff 75 0c             	pushl  0xc(%ebp)
  800d3a:	53                   	push   %ebx
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	ff d0                	call   *%eax
  800d40:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d43:	8b 45 10             	mov    0x10(%ebp),%eax
  800d46:	8d 50 01             	lea    0x1(%eax),%edx
  800d49:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	0f b6 d8             	movzbl %al,%ebx
  800d51:	83 fb 25             	cmp    $0x25,%ebx
  800d54:	75 d6                	jne    800d2c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d56:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d5a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d61:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d68:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d6f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d76:	8b 45 10             	mov    0x10(%ebp),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d7f:	8a 00                	mov    (%eax),%al
  800d81:	0f b6 d8             	movzbl %al,%ebx
  800d84:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d87:	83 f8 55             	cmp    $0x55,%eax
  800d8a:	0f 87 2b 03 00 00    	ja     8010bb <vprintfmt+0x399>
  800d90:	8b 04 85 78 2f 80 00 	mov    0x802f78(,%eax,4),%eax
  800d97:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d99:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d9d:	eb d7                	jmp    800d76 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d9f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800da3:	eb d1                	jmp    800d76 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800da5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800dac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800daf:	89 d0                	mov    %edx,%eax
  800db1:	c1 e0 02             	shl    $0x2,%eax
  800db4:	01 d0                	add    %edx,%eax
  800db6:	01 c0                	add    %eax,%eax
  800db8:	01 d8                	add    %ebx,%eax
  800dba:	83 e8 30             	sub    $0x30,%eax
  800dbd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dc8:	83 fb 2f             	cmp    $0x2f,%ebx
  800dcb:	7e 3e                	jle    800e0b <vprintfmt+0xe9>
  800dcd:	83 fb 39             	cmp    $0x39,%ebx
  800dd0:	7f 39                	jg     800e0b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dd2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dd5:	eb d5                	jmp    800dac <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800dd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dda:	83 c0 04             	add    $0x4,%eax
  800ddd:	89 45 14             	mov    %eax,0x14(%ebp)
  800de0:	8b 45 14             	mov    0x14(%ebp),%eax
  800de3:	83 e8 04             	sub    $0x4,%eax
  800de6:	8b 00                	mov    (%eax),%eax
  800de8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800deb:	eb 1f                	jmp    800e0c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ded:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df1:	79 83                	jns    800d76 <vprintfmt+0x54>
				width = 0;
  800df3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800dfa:	e9 77 ff ff ff       	jmp    800d76 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800dff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e06:	e9 6b ff ff ff       	jmp    800d76 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e0b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e10:	0f 89 60 ff ff ff    	jns    800d76 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e1c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e23:	e9 4e ff ff ff       	jmp    800d76 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e28:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e2b:	e9 46 ff ff ff       	jmp    800d76 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e30:	8b 45 14             	mov    0x14(%ebp),%eax
  800e33:	83 c0 04             	add    $0x4,%eax
  800e36:	89 45 14             	mov    %eax,0x14(%ebp)
  800e39:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3c:	83 e8 04             	sub    $0x4,%eax
  800e3f:	8b 00                	mov    (%eax),%eax
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 0c             	pushl  0xc(%ebp)
  800e47:	50                   	push   %eax
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	ff d0                	call   *%eax
  800e4d:	83 c4 10             	add    $0x10,%esp
			break;
  800e50:	e9 89 02 00 00       	jmp    8010de <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e55:	8b 45 14             	mov    0x14(%ebp),%eax
  800e58:	83 c0 04             	add    $0x4,%eax
  800e5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800e5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e61:	83 e8 04             	sub    $0x4,%eax
  800e64:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e66:	85 db                	test   %ebx,%ebx
  800e68:	79 02                	jns    800e6c <vprintfmt+0x14a>
				err = -err;
  800e6a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e6c:	83 fb 64             	cmp    $0x64,%ebx
  800e6f:	7f 0b                	jg     800e7c <vprintfmt+0x15a>
  800e71:	8b 34 9d c0 2d 80 00 	mov    0x802dc0(,%ebx,4),%esi
  800e78:	85 f6                	test   %esi,%esi
  800e7a:	75 19                	jne    800e95 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e7c:	53                   	push   %ebx
  800e7d:	68 65 2f 80 00       	push   $0x802f65
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	ff 75 08             	pushl  0x8(%ebp)
  800e88:	e8 5e 02 00 00       	call   8010eb <printfmt>
  800e8d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e90:	e9 49 02 00 00       	jmp    8010de <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e95:	56                   	push   %esi
  800e96:	68 6e 2f 80 00       	push   $0x802f6e
  800e9b:	ff 75 0c             	pushl  0xc(%ebp)
  800e9e:	ff 75 08             	pushl  0x8(%ebp)
  800ea1:	e8 45 02 00 00       	call   8010eb <printfmt>
  800ea6:	83 c4 10             	add    $0x10,%esp
			break;
  800ea9:	e9 30 02 00 00       	jmp    8010de <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800eae:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb1:	83 c0 04             	add    $0x4,%eax
  800eb4:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eba:	83 e8 04             	sub    $0x4,%eax
  800ebd:	8b 30                	mov    (%eax),%esi
  800ebf:	85 f6                	test   %esi,%esi
  800ec1:	75 05                	jne    800ec8 <vprintfmt+0x1a6>
				p = "(null)";
  800ec3:	be 71 2f 80 00       	mov    $0x802f71,%esi
			if (width > 0 && padc != '-')
  800ec8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ecc:	7e 6d                	jle    800f3b <vprintfmt+0x219>
  800ece:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ed2:	74 67                	je     800f3b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ed4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ed7:	83 ec 08             	sub    $0x8,%esp
  800eda:	50                   	push   %eax
  800edb:	56                   	push   %esi
  800edc:	e8 12 05 00 00       	call   8013f3 <strnlen>
  800ee1:	83 c4 10             	add    $0x10,%esp
  800ee4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ee7:	eb 16                	jmp    800eff <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ee9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800eed:	83 ec 08             	sub    $0x8,%esp
  800ef0:	ff 75 0c             	pushl  0xc(%ebp)
  800ef3:	50                   	push   %eax
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	ff d0                	call   *%eax
  800ef9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800efc:	ff 4d e4             	decl   -0x1c(%ebp)
  800eff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f03:	7f e4                	jg     800ee9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f05:	eb 34                	jmp    800f3b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f07:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f0b:	74 1c                	je     800f29 <vprintfmt+0x207>
  800f0d:	83 fb 1f             	cmp    $0x1f,%ebx
  800f10:	7e 05                	jle    800f17 <vprintfmt+0x1f5>
  800f12:	83 fb 7e             	cmp    $0x7e,%ebx
  800f15:	7e 12                	jle    800f29 <vprintfmt+0x207>
					putch('?', putdat);
  800f17:	83 ec 08             	sub    $0x8,%esp
  800f1a:	ff 75 0c             	pushl  0xc(%ebp)
  800f1d:	6a 3f                	push   $0x3f
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	ff d0                	call   *%eax
  800f24:	83 c4 10             	add    $0x10,%esp
  800f27:	eb 0f                	jmp    800f38 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f29:	83 ec 08             	sub    $0x8,%esp
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	53                   	push   %ebx
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	ff d0                	call   *%eax
  800f35:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f38:	ff 4d e4             	decl   -0x1c(%ebp)
  800f3b:	89 f0                	mov    %esi,%eax
  800f3d:	8d 70 01             	lea    0x1(%eax),%esi
  800f40:	8a 00                	mov    (%eax),%al
  800f42:	0f be d8             	movsbl %al,%ebx
  800f45:	85 db                	test   %ebx,%ebx
  800f47:	74 24                	je     800f6d <vprintfmt+0x24b>
  800f49:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f4d:	78 b8                	js     800f07 <vprintfmt+0x1e5>
  800f4f:	ff 4d e0             	decl   -0x20(%ebp)
  800f52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f56:	79 af                	jns    800f07 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f58:	eb 13                	jmp    800f6d <vprintfmt+0x24b>
				putch(' ', putdat);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	6a 20                	push   $0x20
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff d0                	call   *%eax
  800f67:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f6a:	ff 4d e4             	decl   -0x1c(%ebp)
  800f6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f71:	7f e7                	jg     800f5a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f73:	e9 66 01 00 00       	jmp    8010de <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f78:	83 ec 08             	sub    $0x8,%esp
  800f7b:	ff 75 e8             	pushl  -0x18(%ebp)
  800f7e:	8d 45 14             	lea    0x14(%ebp),%eax
  800f81:	50                   	push   %eax
  800f82:	e8 3c fd ff ff       	call   800cc3 <getint>
  800f87:	83 c4 10             	add    $0x10,%esp
  800f8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f8d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f96:	85 d2                	test   %edx,%edx
  800f98:	79 23                	jns    800fbd <vprintfmt+0x29b>
				putch('-', putdat);
  800f9a:	83 ec 08             	sub    $0x8,%esp
  800f9d:	ff 75 0c             	pushl  0xc(%ebp)
  800fa0:	6a 2d                	push   $0x2d
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	ff d0                	call   *%eax
  800fa7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb0:	f7 d8                	neg    %eax
  800fb2:	83 d2 00             	adc    $0x0,%edx
  800fb5:	f7 da                	neg    %edx
  800fb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fbd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fc4:	e9 bc 00 00 00       	jmp    801085 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fc9:	83 ec 08             	sub    $0x8,%esp
  800fcc:	ff 75 e8             	pushl  -0x18(%ebp)
  800fcf:	8d 45 14             	lea    0x14(%ebp),%eax
  800fd2:	50                   	push   %eax
  800fd3:	e8 84 fc ff ff       	call   800c5c <getuint>
  800fd8:	83 c4 10             	add    $0x10,%esp
  800fdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fde:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fe1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fe8:	e9 98 00 00 00       	jmp    801085 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fed:	83 ec 08             	sub    $0x8,%esp
  800ff0:	ff 75 0c             	pushl  0xc(%ebp)
  800ff3:	6a 58                	push   $0x58
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	ff d0                	call   *%eax
  800ffa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ffd:	83 ec 08             	sub    $0x8,%esp
  801000:	ff 75 0c             	pushl  0xc(%ebp)
  801003:	6a 58                	push   $0x58
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	ff d0                	call   *%eax
  80100a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80100d:	83 ec 08             	sub    $0x8,%esp
  801010:	ff 75 0c             	pushl  0xc(%ebp)
  801013:	6a 58                	push   $0x58
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	ff d0                	call   *%eax
  80101a:	83 c4 10             	add    $0x10,%esp
			break;
  80101d:	e9 bc 00 00 00       	jmp    8010de <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801022:	83 ec 08             	sub    $0x8,%esp
  801025:	ff 75 0c             	pushl  0xc(%ebp)
  801028:	6a 30                	push   $0x30
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	ff d0                	call   *%eax
  80102f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801032:	83 ec 08             	sub    $0x8,%esp
  801035:	ff 75 0c             	pushl  0xc(%ebp)
  801038:	6a 78                	push   $0x78
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	ff d0                	call   *%eax
  80103f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801042:	8b 45 14             	mov    0x14(%ebp),%eax
  801045:	83 c0 04             	add    $0x4,%eax
  801048:	89 45 14             	mov    %eax,0x14(%ebp)
  80104b:	8b 45 14             	mov    0x14(%ebp),%eax
  80104e:	83 e8 04             	sub    $0x4,%eax
  801051:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801053:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801056:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80105d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801064:	eb 1f                	jmp    801085 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801066:	83 ec 08             	sub    $0x8,%esp
  801069:	ff 75 e8             	pushl  -0x18(%ebp)
  80106c:	8d 45 14             	lea    0x14(%ebp),%eax
  80106f:	50                   	push   %eax
  801070:	e8 e7 fb ff ff       	call   800c5c <getuint>
  801075:	83 c4 10             	add    $0x10,%esp
  801078:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80107b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80107e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801085:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801089:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80108c:	83 ec 04             	sub    $0x4,%esp
  80108f:	52                   	push   %edx
  801090:	ff 75 e4             	pushl  -0x1c(%ebp)
  801093:	50                   	push   %eax
  801094:	ff 75 f4             	pushl  -0xc(%ebp)
  801097:	ff 75 f0             	pushl  -0x10(%ebp)
  80109a:	ff 75 0c             	pushl  0xc(%ebp)
  80109d:	ff 75 08             	pushl  0x8(%ebp)
  8010a0:	e8 00 fb ff ff       	call   800ba5 <printnum>
  8010a5:	83 c4 20             	add    $0x20,%esp
			break;
  8010a8:	eb 34                	jmp    8010de <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	53                   	push   %ebx
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	ff d0                	call   *%eax
  8010b6:	83 c4 10             	add    $0x10,%esp
			break;
  8010b9:	eb 23                	jmp    8010de <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010bb:	83 ec 08             	sub    $0x8,%esp
  8010be:	ff 75 0c             	pushl  0xc(%ebp)
  8010c1:	6a 25                	push   $0x25
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	ff d0                	call   *%eax
  8010c8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010cb:	ff 4d 10             	decl   0x10(%ebp)
  8010ce:	eb 03                	jmp    8010d3 <vprintfmt+0x3b1>
  8010d0:	ff 4d 10             	decl   0x10(%ebp)
  8010d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d6:	48                   	dec    %eax
  8010d7:	8a 00                	mov    (%eax),%al
  8010d9:	3c 25                	cmp    $0x25,%al
  8010db:	75 f3                	jne    8010d0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8010dd:	90                   	nop
		}
	}
  8010de:	e9 47 fc ff ff       	jmp    800d2a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010e3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010e7:	5b                   	pop    %ebx
  8010e8:	5e                   	pop    %esi
  8010e9:	5d                   	pop    %ebp
  8010ea:	c3                   	ret    

008010eb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010f1:	8d 45 10             	lea    0x10(%ebp),%eax
  8010f4:	83 c0 04             	add    $0x4,%eax
  8010f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801100:	50                   	push   %eax
  801101:	ff 75 0c             	pushl  0xc(%ebp)
  801104:	ff 75 08             	pushl  0x8(%ebp)
  801107:	e8 16 fc ff ff       	call   800d22 <vprintfmt>
  80110c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80110f:	90                   	nop
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801115:	8b 45 0c             	mov    0xc(%ebp),%eax
  801118:	8b 40 08             	mov    0x8(%eax),%eax
  80111b:	8d 50 01             	lea    0x1(%eax),%edx
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	8b 10                	mov    (%eax),%edx
  801129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112c:	8b 40 04             	mov    0x4(%eax),%eax
  80112f:	39 c2                	cmp    %eax,%edx
  801131:	73 12                	jae    801145 <sprintputch+0x33>
		*b->buf++ = ch;
  801133:	8b 45 0c             	mov    0xc(%ebp),%eax
  801136:	8b 00                	mov    (%eax),%eax
  801138:	8d 48 01             	lea    0x1(%eax),%ecx
  80113b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80113e:	89 0a                	mov    %ecx,(%edx)
  801140:	8b 55 08             	mov    0x8(%ebp),%edx
  801143:	88 10                	mov    %dl,(%eax)
}
  801145:	90                   	nop
  801146:	5d                   	pop    %ebp
  801147:	c3                   	ret    

00801148 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	8d 50 ff             	lea    -0x1(%eax),%edx
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	01 d0                	add    %edx,%eax
  80115f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801162:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801169:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80116d:	74 06                	je     801175 <vsnprintf+0x2d>
  80116f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801173:	7f 07                	jg     80117c <vsnprintf+0x34>
		return -E_INVAL;
  801175:	b8 03 00 00 00       	mov    $0x3,%eax
  80117a:	eb 20                	jmp    80119c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80117c:	ff 75 14             	pushl  0x14(%ebp)
  80117f:	ff 75 10             	pushl  0x10(%ebp)
  801182:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801185:	50                   	push   %eax
  801186:	68 12 11 80 00       	push   $0x801112
  80118b:	e8 92 fb ff ff       	call   800d22 <vprintfmt>
  801190:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801193:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801196:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801199:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80119c:	c9                   	leave  
  80119d:	c3                   	ret    

0080119e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8011a7:	83 c0 04             	add    $0x4,%eax
  8011aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b3:	50                   	push   %eax
  8011b4:	ff 75 0c             	pushl  0xc(%ebp)
  8011b7:	ff 75 08             	pushl  0x8(%ebp)
  8011ba:	e8 89 ff ff ff       	call   801148 <vsnprintf>
  8011bf:	83 c4 10             	add    $0x10,%esp
  8011c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8011d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d4:	74 13                	je     8011e9 <readline+0x1f>
		cprintf("%s", prompt);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 08             	pushl  0x8(%ebp)
  8011dc:	68 d0 30 80 00       	push   $0x8030d0
  8011e1:	e8 62 f9 ff ff       	call   800b48 <cprintf>
  8011e6:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	6a 00                	push   $0x0
  8011f5:	e8 5d f5 ff ff       	call   800757 <iscons>
  8011fa:	83 c4 10             	add    $0x10,%esp
  8011fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801200:	e8 04 f5 ff ff       	call   800709 <getchar>
  801205:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801208:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80120c:	79 22                	jns    801230 <readline+0x66>
			if (c != -E_EOF)
  80120e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801212:	0f 84 ad 00 00 00    	je     8012c5 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801218:	83 ec 08             	sub    $0x8,%esp
  80121b:	ff 75 ec             	pushl  -0x14(%ebp)
  80121e:	68 d3 30 80 00       	push   $0x8030d3
  801223:	e8 20 f9 ff ff       	call   800b48 <cprintf>
  801228:	83 c4 10             	add    $0x10,%esp
			return;
  80122b:	e9 95 00 00 00       	jmp    8012c5 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801230:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801234:	7e 34                	jle    80126a <readline+0xa0>
  801236:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80123d:	7f 2b                	jg     80126a <readline+0xa0>
			if (echoing)
  80123f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801243:	74 0e                	je     801253 <readline+0x89>
				cputchar(c);
  801245:	83 ec 0c             	sub    $0xc,%esp
  801248:	ff 75 ec             	pushl  -0x14(%ebp)
  80124b:	e8 71 f4 ff ff       	call   8006c1 <cputchar>
  801250:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801256:	8d 50 01             	lea    0x1(%eax),%edx
  801259:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80125c:	89 c2                	mov    %eax,%edx
  80125e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801261:	01 d0                	add    %edx,%eax
  801263:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801266:	88 10                	mov    %dl,(%eax)
  801268:	eb 56                	jmp    8012c0 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80126a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80126e:	75 1f                	jne    80128f <readline+0xc5>
  801270:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801274:	7e 19                	jle    80128f <readline+0xc5>
			if (echoing)
  801276:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80127a:	74 0e                	je     80128a <readline+0xc0>
				cputchar(c);
  80127c:	83 ec 0c             	sub    $0xc,%esp
  80127f:	ff 75 ec             	pushl  -0x14(%ebp)
  801282:	e8 3a f4 ff ff       	call   8006c1 <cputchar>
  801287:	83 c4 10             	add    $0x10,%esp

			i--;
  80128a:	ff 4d f4             	decl   -0xc(%ebp)
  80128d:	eb 31                	jmp    8012c0 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80128f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801293:	74 0a                	je     80129f <readline+0xd5>
  801295:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801299:	0f 85 61 ff ff ff    	jne    801200 <readline+0x36>
			if (echoing)
  80129f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012a3:	74 0e                	je     8012b3 <readline+0xe9>
				cputchar(c);
  8012a5:	83 ec 0c             	sub    $0xc,%esp
  8012a8:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ab:	e8 11 f4 ff ff       	call   8006c1 <cputchar>
  8012b0:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	01 d0                	add    %edx,%eax
  8012bb:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8012be:	eb 06                	jmp    8012c6 <readline+0xfc>
		}
	}
  8012c0:	e9 3b ff ff ff       	jmp    801200 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8012c5:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

008012c8 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8012ce:	e8 aa 0f 00 00       	call   80227d <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8012d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d7:	74 13                	je     8012ec <atomic_readline+0x24>
		cprintf("%s", prompt);
  8012d9:	83 ec 08             	sub    $0x8,%esp
  8012dc:	ff 75 08             	pushl  0x8(%ebp)
  8012df:	68 d0 30 80 00       	push   $0x8030d0
  8012e4:	e8 5f f8 ff ff       	call   800b48 <cprintf>
  8012e9:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012f3:	83 ec 0c             	sub    $0xc,%esp
  8012f6:	6a 00                	push   $0x0
  8012f8:	e8 5a f4 ff ff       	call   800757 <iscons>
  8012fd:	83 c4 10             	add    $0x10,%esp
  801300:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801303:	e8 01 f4 ff ff       	call   800709 <getchar>
  801308:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80130b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80130f:	79 23                	jns    801334 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801311:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801315:	74 13                	je     80132a <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801317:	83 ec 08             	sub    $0x8,%esp
  80131a:	ff 75 ec             	pushl  -0x14(%ebp)
  80131d:	68 d3 30 80 00       	push   $0x8030d3
  801322:	e8 21 f8 ff ff       	call   800b48 <cprintf>
  801327:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80132a:	e8 68 0f 00 00       	call   802297 <sys_enable_interrupt>
			return;
  80132f:	e9 9a 00 00 00       	jmp    8013ce <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801334:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801338:	7e 34                	jle    80136e <atomic_readline+0xa6>
  80133a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801341:	7f 2b                	jg     80136e <atomic_readline+0xa6>
			if (echoing)
  801343:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801347:	74 0e                	je     801357 <atomic_readline+0x8f>
				cputchar(c);
  801349:	83 ec 0c             	sub    $0xc,%esp
  80134c:	ff 75 ec             	pushl  -0x14(%ebp)
  80134f:	e8 6d f3 ff ff       	call   8006c1 <cputchar>
  801354:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	8d 50 01             	lea    0x1(%eax),%edx
  80135d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801360:	89 c2                	mov    %eax,%edx
  801362:	8b 45 0c             	mov    0xc(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80136a:	88 10                	mov    %dl,(%eax)
  80136c:	eb 5b                	jmp    8013c9 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80136e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801372:	75 1f                	jne    801393 <atomic_readline+0xcb>
  801374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801378:	7e 19                	jle    801393 <atomic_readline+0xcb>
			if (echoing)
  80137a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80137e:	74 0e                	je     80138e <atomic_readline+0xc6>
				cputchar(c);
  801380:	83 ec 0c             	sub    $0xc,%esp
  801383:	ff 75 ec             	pushl  -0x14(%ebp)
  801386:	e8 36 f3 ff ff       	call   8006c1 <cputchar>
  80138b:	83 c4 10             	add    $0x10,%esp
			i--;
  80138e:	ff 4d f4             	decl   -0xc(%ebp)
  801391:	eb 36                	jmp    8013c9 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801393:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801397:	74 0a                	je     8013a3 <atomic_readline+0xdb>
  801399:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80139d:	0f 85 60 ff ff ff    	jne    801303 <atomic_readline+0x3b>
			if (echoing)
  8013a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013a7:	74 0e                	je     8013b7 <atomic_readline+0xef>
				cputchar(c);
  8013a9:	83 ec 0c             	sub    $0xc,%esp
  8013ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8013af:	e8 0d f3 ff ff       	call   8006c1 <cputchar>
  8013b4:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bd:	01 d0                	add    %edx,%eax
  8013bf:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8013c2:	e8 d0 0e 00 00       	call   802297 <sys_enable_interrupt>
			return;
  8013c7:	eb 05                	jmp    8013ce <atomic_readline+0x106>
		}
	}
  8013c9:	e9 35 ff ff ff       	jmp    801303 <atomic_readline+0x3b>
}
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013dd:	eb 06                	jmp    8013e5 <strlen+0x15>
		n++;
  8013df:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013e2:	ff 45 08             	incl   0x8(%ebp)
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	8a 00                	mov    (%eax),%al
  8013ea:	84 c0                	test   %al,%al
  8013ec:	75 f1                	jne    8013df <strlen+0xf>
		n++;
	return n;
  8013ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801400:	eb 09                	jmp    80140b <strnlen+0x18>
		n++;
  801402:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801405:	ff 45 08             	incl   0x8(%ebp)
  801408:	ff 4d 0c             	decl   0xc(%ebp)
  80140b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80140f:	74 09                	je     80141a <strnlen+0x27>
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	84 c0                	test   %al,%al
  801418:	75 e8                	jne    801402 <strnlen+0xf>
		n++;
	return n;
  80141a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80142b:	90                   	nop
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8d 50 01             	lea    0x1(%eax),%edx
  801432:	89 55 08             	mov    %edx,0x8(%ebp)
  801435:	8b 55 0c             	mov    0xc(%ebp),%edx
  801438:	8d 4a 01             	lea    0x1(%edx),%ecx
  80143b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80143e:	8a 12                	mov    (%edx),%dl
  801440:	88 10                	mov    %dl,(%eax)
  801442:	8a 00                	mov    (%eax),%al
  801444:	84 c0                	test   %al,%al
  801446:	75 e4                	jne    80142c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801448:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801459:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801460:	eb 1f                	jmp    801481 <strncpy+0x34>
		*dst++ = *src;
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	8d 50 01             	lea    0x1(%eax),%edx
  801468:	89 55 08             	mov    %edx,0x8(%ebp)
  80146b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146e:	8a 12                	mov    (%edx),%dl
  801470:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801472:	8b 45 0c             	mov    0xc(%ebp),%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	84 c0                	test   %al,%al
  801479:	74 03                	je     80147e <strncpy+0x31>
			src++;
  80147b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80147e:	ff 45 fc             	incl   -0x4(%ebp)
  801481:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801484:	3b 45 10             	cmp    0x10(%ebp),%eax
  801487:	72 d9                	jb     801462 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801489:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    

0080148e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80149a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80149e:	74 30                	je     8014d0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014a0:	eb 16                	jmp    8014b8 <strlcpy+0x2a>
			*dst++ = *src++;
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	8d 50 01             	lea    0x1(%eax),%edx
  8014a8:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014b1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014b4:	8a 12                	mov    (%edx),%dl
  8014b6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014b8:	ff 4d 10             	decl   0x10(%ebp)
  8014bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014bf:	74 09                	je     8014ca <strlcpy+0x3c>
  8014c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c4:	8a 00                	mov    (%eax),%al
  8014c6:	84 c0                	test   %al,%al
  8014c8:	75 d8                	jne    8014a2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d6:	29 c2                	sub    %eax,%edx
  8014d8:	89 d0                	mov    %edx,%eax
}
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014df:	eb 06                	jmp    8014e7 <strcmp+0xb>
		p++, q++;
  8014e1:	ff 45 08             	incl   0x8(%ebp)
  8014e4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	84 c0                	test   %al,%al
  8014ee:	74 0e                	je     8014fe <strcmp+0x22>
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 10                	mov    (%eax),%dl
  8014f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f8:	8a 00                	mov    (%eax),%al
  8014fa:	38 c2                	cmp    %al,%dl
  8014fc:	74 e3                	je     8014e1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	0f b6 d0             	movzbl %al,%edx
  801506:	8b 45 0c             	mov    0xc(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	0f b6 c0             	movzbl %al,%eax
  80150e:	29 c2                	sub    %eax,%edx
  801510:	89 d0                	mov    %edx,%eax
}
  801512:	5d                   	pop    %ebp
  801513:	c3                   	ret    

00801514 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801517:	eb 09                	jmp    801522 <strncmp+0xe>
		n--, p++, q++;
  801519:	ff 4d 10             	decl   0x10(%ebp)
  80151c:	ff 45 08             	incl   0x8(%ebp)
  80151f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801522:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801526:	74 17                	je     80153f <strncmp+0x2b>
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	8a 00                	mov    (%eax),%al
  80152d:	84 c0                	test   %al,%al
  80152f:	74 0e                	je     80153f <strncmp+0x2b>
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8a 10                	mov    (%eax),%dl
  801536:	8b 45 0c             	mov    0xc(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	38 c2                	cmp    %al,%dl
  80153d:	74 da                	je     801519 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80153f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801543:	75 07                	jne    80154c <strncmp+0x38>
		return 0;
  801545:	b8 00 00 00 00       	mov    $0x0,%eax
  80154a:	eb 14                	jmp    801560 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	0f b6 d0             	movzbl %al,%edx
  801554:	8b 45 0c             	mov    0xc(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	0f b6 c0             	movzbl %al,%eax
  80155c:	29 c2                	sub    %eax,%edx
  80155e:	89 d0                	mov    %edx,%eax
}
  801560:	5d                   	pop    %ebp
  801561:	c3                   	ret    

00801562 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 04             	sub    $0x4,%esp
  801568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80156e:	eb 12                	jmp    801582 <strchr+0x20>
		if (*s == c)
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801578:	75 05                	jne    80157f <strchr+0x1d>
			return (char *) s;
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	eb 11                	jmp    801590 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80157f:	ff 45 08             	incl   0x8(%ebp)
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	8a 00                	mov    (%eax),%al
  801587:	84 c0                	test   %al,%al
  801589:	75 e5                	jne    801570 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80158b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 04             	sub    $0x4,%esp
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80159e:	eb 0d                	jmp    8015ad <strfind+0x1b>
		if (*s == c)
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	8a 00                	mov    (%eax),%al
  8015a5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015a8:	74 0e                	je     8015b8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015aa:	ff 45 08             	incl   0x8(%ebp)
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	84 c0                	test   %al,%al
  8015b4:	75 ea                	jne    8015a0 <strfind+0xe>
  8015b6:	eb 01                	jmp    8015b9 <strfind+0x27>
		if (*s == c)
			break;
  8015b8:	90                   	nop
	return (char *) s;
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015d0:	eb 0e                	jmp    8015e0 <memset+0x22>
		*p++ = c;
  8015d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d5:	8d 50 01             	lea    0x1(%eax),%edx
  8015d8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015de:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015e0:	ff 4d f8             	decl   -0x8(%ebp)
  8015e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015e7:	79 e9                	jns    8015d2 <memset+0x14>
		*p++ = c;

	return v;
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801600:	eb 16                	jmp    801618 <memcpy+0x2a>
		*d++ = *s++;
  801602:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801605:	8d 50 01             	lea    0x1(%eax),%edx
  801608:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80160b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801611:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801614:	8a 12                	mov    (%edx),%dl
  801616:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801618:	8b 45 10             	mov    0x10(%ebp),%eax
  80161b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80161e:	89 55 10             	mov    %edx,0x10(%ebp)
  801621:	85 c0                	test   %eax,%eax
  801623:	75 dd                	jne    801602 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801630:	8b 45 0c             	mov    0xc(%ebp),%eax
  801633:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80163c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801642:	73 50                	jae    801694 <memmove+0x6a>
  801644:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801647:	8b 45 10             	mov    0x10(%ebp),%eax
  80164a:	01 d0                	add    %edx,%eax
  80164c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80164f:	76 43                	jbe    801694 <memmove+0x6a>
		s += n;
  801651:	8b 45 10             	mov    0x10(%ebp),%eax
  801654:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801657:	8b 45 10             	mov    0x10(%ebp),%eax
  80165a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80165d:	eb 10                	jmp    80166f <memmove+0x45>
			*--d = *--s;
  80165f:	ff 4d f8             	decl   -0x8(%ebp)
  801662:	ff 4d fc             	decl   -0x4(%ebp)
  801665:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801668:	8a 10                	mov    (%eax),%dl
  80166a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80166d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80166f:	8b 45 10             	mov    0x10(%ebp),%eax
  801672:	8d 50 ff             	lea    -0x1(%eax),%edx
  801675:	89 55 10             	mov    %edx,0x10(%ebp)
  801678:	85 c0                	test   %eax,%eax
  80167a:	75 e3                	jne    80165f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80167c:	eb 23                	jmp    8016a1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80167e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801681:	8d 50 01             	lea    0x1(%eax),%edx
  801684:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801687:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80168d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801690:	8a 12                	mov    (%edx),%dl
  801692:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801694:	8b 45 10             	mov    0x10(%ebp),%eax
  801697:	8d 50 ff             	lea    -0x1(%eax),%edx
  80169a:	89 55 10             	mov    %edx,0x10(%ebp)
  80169d:	85 c0                	test   %eax,%eax
  80169f:	75 dd                	jne    80167e <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016b8:	eb 2a                	jmp    8016e4 <memcmp+0x3e>
		if (*s1 != *s2)
  8016ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bd:	8a 10                	mov    (%eax),%dl
  8016bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c2:	8a 00                	mov    (%eax),%al
  8016c4:	38 c2                	cmp    %al,%dl
  8016c6:	74 16                	je     8016de <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	0f b6 d0             	movzbl %al,%edx
  8016d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d3:	8a 00                	mov    (%eax),%al
  8016d5:	0f b6 c0             	movzbl %al,%eax
  8016d8:	29 c2                	sub    %eax,%edx
  8016da:	89 d0                	mov    %edx,%eax
  8016dc:	eb 18                	jmp    8016f6 <memcmp+0x50>
		s1++, s2++;
  8016de:	ff 45 fc             	incl   -0x4(%ebp)
  8016e1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	75 c9                	jne    8016ba <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	01 d0                	add    %edx,%eax
  801706:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801709:	eb 15                	jmp    801720 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	8a 00                	mov    (%eax),%al
  801710:	0f b6 d0             	movzbl %al,%edx
  801713:	8b 45 0c             	mov    0xc(%ebp),%eax
  801716:	0f b6 c0             	movzbl %al,%eax
  801719:	39 c2                	cmp    %eax,%edx
  80171b:	74 0d                	je     80172a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80171d:	ff 45 08             	incl   0x8(%ebp)
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801726:	72 e3                	jb     80170b <memfind+0x13>
  801728:	eb 01                	jmp    80172b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80172a:	90                   	nop
	return (void *) s;
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801736:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80173d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801744:	eb 03                	jmp    801749 <strtol+0x19>
		s++;
  801746:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	8a 00                	mov    (%eax),%al
  80174e:	3c 20                	cmp    $0x20,%al
  801750:	74 f4                	je     801746 <strtol+0x16>
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	3c 09                	cmp    $0x9,%al
  801759:	74 eb                	je     801746 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	3c 2b                	cmp    $0x2b,%al
  801762:	75 05                	jne    801769 <strtol+0x39>
		s++;
  801764:	ff 45 08             	incl   0x8(%ebp)
  801767:	eb 13                	jmp    80177c <strtol+0x4c>
	else if (*s == '-')
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	8a 00                	mov    (%eax),%al
  80176e:	3c 2d                	cmp    $0x2d,%al
  801770:	75 0a                	jne    80177c <strtol+0x4c>
		s++, neg = 1;
  801772:	ff 45 08             	incl   0x8(%ebp)
  801775:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80177c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801780:	74 06                	je     801788 <strtol+0x58>
  801782:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801786:	75 20                	jne    8017a8 <strtol+0x78>
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	8a 00                	mov    (%eax),%al
  80178d:	3c 30                	cmp    $0x30,%al
  80178f:	75 17                	jne    8017a8 <strtol+0x78>
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	40                   	inc    %eax
  801795:	8a 00                	mov    (%eax),%al
  801797:	3c 78                	cmp    $0x78,%al
  801799:	75 0d                	jne    8017a8 <strtol+0x78>
		s += 2, base = 16;
  80179b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80179f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017a6:	eb 28                	jmp    8017d0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ac:	75 15                	jne    8017c3 <strtol+0x93>
  8017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b1:	8a 00                	mov    (%eax),%al
  8017b3:	3c 30                	cmp    $0x30,%al
  8017b5:	75 0c                	jne    8017c3 <strtol+0x93>
		s++, base = 8;
  8017b7:	ff 45 08             	incl   0x8(%ebp)
  8017ba:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017c1:	eb 0d                	jmp    8017d0 <strtol+0xa0>
	else if (base == 0)
  8017c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c7:	75 07                	jne    8017d0 <strtol+0xa0>
		base = 10;
  8017c9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	8a 00                	mov    (%eax),%al
  8017d5:	3c 2f                	cmp    $0x2f,%al
  8017d7:	7e 19                	jle    8017f2 <strtol+0xc2>
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8a 00                	mov    (%eax),%al
  8017de:	3c 39                	cmp    $0x39,%al
  8017e0:	7f 10                	jg     8017f2 <strtol+0xc2>
			dig = *s - '0';
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	0f be c0             	movsbl %al,%eax
  8017ea:	83 e8 30             	sub    $0x30,%eax
  8017ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f0:	eb 42                	jmp    801834 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f5:	8a 00                	mov    (%eax),%al
  8017f7:	3c 60                	cmp    $0x60,%al
  8017f9:	7e 19                	jle    801814 <strtol+0xe4>
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8a 00                	mov    (%eax),%al
  801800:	3c 7a                	cmp    $0x7a,%al
  801802:	7f 10                	jg     801814 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8a 00                	mov    (%eax),%al
  801809:	0f be c0             	movsbl %al,%eax
  80180c:	83 e8 57             	sub    $0x57,%eax
  80180f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801812:	eb 20                	jmp    801834 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	8a 00                	mov    (%eax),%al
  801819:	3c 40                	cmp    $0x40,%al
  80181b:	7e 39                	jle    801856 <strtol+0x126>
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	8a 00                	mov    (%eax),%al
  801822:	3c 5a                	cmp    $0x5a,%al
  801824:	7f 30                	jg     801856 <strtol+0x126>
			dig = *s - 'A' + 10;
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	0f be c0             	movsbl %al,%eax
  80182e:	83 e8 37             	sub    $0x37,%eax
  801831:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801837:	3b 45 10             	cmp    0x10(%ebp),%eax
  80183a:	7d 19                	jge    801855 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80183c:	ff 45 08             	incl   0x8(%ebp)
  80183f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801842:	0f af 45 10          	imul   0x10(%ebp),%eax
  801846:	89 c2                	mov    %eax,%edx
  801848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184b:	01 d0                	add    %edx,%eax
  80184d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801850:	e9 7b ff ff ff       	jmp    8017d0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801855:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801856:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80185a:	74 08                	je     801864 <strtol+0x134>
		*endptr = (char *) s;
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	8b 55 08             	mov    0x8(%ebp),%edx
  801862:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801864:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801868:	74 07                	je     801871 <strtol+0x141>
  80186a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186d:	f7 d8                	neg    %eax
  80186f:	eb 03                	jmp    801874 <strtol+0x144>
  801871:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <ltostr>:

void
ltostr(long value, char *str)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80187c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801883:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80188a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80188e:	79 13                	jns    8018a3 <ltostr+0x2d>
	{
		neg = 1;
  801890:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801897:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80189d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018a0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018ab:	99                   	cltd   
  8018ac:	f7 f9                	idiv   %ecx
  8018ae:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b4:	8d 50 01             	lea    0x1(%eax),%edx
  8018b7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018ba:	89 c2                	mov    %eax,%edx
  8018bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bf:	01 d0                	add    %edx,%eax
  8018c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018c4:	83 c2 30             	add    $0x30,%edx
  8018c7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018cc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018d1:	f7 e9                	imul   %ecx
  8018d3:	c1 fa 02             	sar    $0x2,%edx
  8018d6:	89 c8                	mov    %ecx,%eax
  8018d8:	c1 f8 1f             	sar    $0x1f,%eax
  8018db:	29 c2                	sub    %eax,%edx
  8018dd:	89 d0                	mov    %edx,%eax
  8018df:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018ea:	f7 e9                	imul   %ecx
  8018ec:	c1 fa 02             	sar    $0x2,%edx
  8018ef:	89 c8                	mov    %ecx,%eax
  8018f1:	c1 f8 1f             	sar    $0x1f,%eax
  8018f4:	29 c2                	sub    %eax,%edx
  8018f6:	89 d0                	mov    %edx,%eax
  8018f8:	c1 e0 02             	shl    $0x2,%eax
  8018fb:	01 d0                	add    %edx,%eax
  8018fd:	01 c0                	add    %eax,%eax
  8018ff:	29 c1                	sub    %eax,%ecx
  801901:	89 ca                	mov    %ecx,%edx
  801903:	85 d2                	test   %edx,%edx
  801905:	75 9c                	jne    8018a3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801907:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80190e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801911:	48                   	dec    %eax
  801912:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801915:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801919:	74 3d                	je     801958 <ltostr+0xe2>
		start = 1 ;
  80191b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801922:	eb 34                	jmp    801958 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801924:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801927:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192a:	01 d0                	add    %edx,%eax
  80192c:	8a 00                	mov    (%eax),%al
  80192e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801931:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801934:	8b 45 0c             	mov    0xc(%ebp),%eax
  801937:	01 c2                	add    %eax,%edx
  801939:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80193c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193f:	01 c8                	add    %ecx,%eax
  801941:	8a 00                	mov    (%eax),%al
  801943:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801945:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194b:	01 c2                	add    %eax,%edx
  80194d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801950:	88 02                	mov    %al,(%edx)
		start++ ;
  801952:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801955:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80195e:	7c c4                	jl     801924 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801960:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801963:	8b 45 0c             	mov    0xc(%ebp),%eax
  801966:	01 d0                	add    %edx,%eax
  801968:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80196b:	90                   	nop
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801974:	ff 75 08             	pushl  0x8(%ebp)
  801977:	e8 54 fa ff ff       	call   8013d0 <strlen>
  80197c:	83 c4 04             	add    $0x4,%esp
  80197f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801982:	ff 75 0c             	pushl  0xc(%ebp)
  801985:	e8 46 fa ff ff       	call   8013d0 <strlen>
  80198a:	83 c4 04             	add    $0x4,%esp
  80198d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801990:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801997:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80199e:	eb 17                	jmp    8019b7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a6:	01 c2                	add    %eax,%edx
  8019a8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	01 c8                	add    %ecx,%eax
  8019b0:	8a 00                	mov    (%eax),%al
  8019b2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019b4:	ff 45 fc             	incl   -0x4(%ebp)
  8019b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019bd:	7c e1                	jl     8019a0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019cd:	eb 1f                	jmp    8019ee <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d2:	8d 50 01             	lea    0x1(%eax),%edx
  8019d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019d8:	89 c2                	mov    %eax,%edx
  8019da:	8b 45 10             	mov    0x10(%ebp),%eax
  8019dd:	01 c2                	add    %eax,%edx
  8019df:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e5:	01 c8                	add    %ecx,%eax
  8019e7:	8a 00                	mov    (%eax),%al
  8019e9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019eb:	ff 45 f8             	incl   -0x8(%ebp)
  8019ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019f4:	7c d9                	jl     8019cf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fc:	01 d0                	add    %edx,%eax
  8019fe:	c6 00 00             	movb   $0x0,(%eax)
}
  801a01:	90                   	nop
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a07:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a10:	8b 45 14             	mov    0x14(%ebp),%eax
  801a13:	8b 00                	mov    (%eax),%eax
  801a15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a1f:	01 d0                	add    %edx,%eax
  801a21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a27:	eb 0c                	jmp    801a35 <strsplit+0x31>
			*string++ = 0;
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8d 50 01             	lea    0x1(%eax),%edx
  801a2f:	89 55 08             	mov    %edx,0x8(%ebp)
  801a32:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a35:	8b 45 08             	mov    0x8(%ebp),%eax
  801a38:	8a 00                	mov    (%eax),%al
  801a3a:	84 c0                	test   %al,%al
  801a3c:	74 18                	je     801a56 <strsplit+0x52>
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	0f be c0             	movsbl %al,%eax
  801a46:	50                   	push   %eax
  801a47:	ff 75 0c             	pushl  0xc(%ebp)
  801a4a:	e8 13 fb ff ff       	call   801562 <strchr>
  801a4f:	83 c4 08             	add    $0x8,%esp
  801a52:	85 c0                	test   %eax,%eax
  801a54:	75 d3                	jne    801a29 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	8a 00                	mov    (%eax),%al
  801a5b:	84 c0                	test   %al,%al
  801a5d:	74 5a                	je     801ab9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a5f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a62:	8b 00                	mov    (%eax),%eax
  801a64:	83 f8 0f             	cmp    $0xf,%eax
  801a67:	75 07                	jne    801a70 <strsplit+0x6c>
		{
			return 0;
  801a69:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6e:	eb 66                	jmp    801ad6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a70:	8b 45 14             	mov    0x14(%ebp),%eax
  801a73:	8b 00                	mov    (%eax),%eax
  801a75:	8d 48 01             	lea    0x1(%eax),%ecx
  801a78:	8b 55 14             	mov    0x14(%ebp),%edx
  801a7b:	89 0a                	mov    %ecx,(%edx)
  801a7d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a84:	8b 45 10             	mov    0x10(%ebp),%eax
  801a87:	01 c2                	add    %eax,%edx
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a8e:	eb 03                	jmp    801a93 <strsplit+0x8f>
			string++;
  801a90:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	8a 00                	mov    (%eax),%al
  801a98:	84 c0                	test   %al,%al
  801a9a:	74 8b                	je     801a27 <strsplit+0x23>
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8a 00                	mov    (%eax),%al
  801aa1:	0f be c0             	movsbl %al,%eax
  801aa4:	50                   	push   %eax
  801aa5:	ff 75 0c             	pushl  0xc(%ebp)
  801aa8:	e8 b5 fa ff ff       	call   801562 <strchr>
  801aad:	83 c4 08             	add    $0x8,%esp
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	74 dc                	je     801a90 <strsplit+0x8c>
			string++;
	}
  801ab4:	e9 6e ff ff ff       	jmp    801a27 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ab9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801aba:	8b 45 14             	mov    0x14(%ebp),%eax
  801abd:	8b 00                	mov    (%eax),%eax
  801abf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac9:	01 d0                	add    %edx,%eax
  801acb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ad1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  801ade:	a1 28 40 80 00       	mov    0x804028,%eax
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	75 33                	jne    801b1a <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801ae7:	c7 05 20 41 80 00 00 	movl   $0x80000000,0x804120
  801aee:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  801af1:	c7 05 24 41 80 00 00 	movl   $0xa0000000,0x804124
  801af8:	00 00 a0 
		spaces[0].pages = numPages;
  801afb:	c7 05 28 41 80 00 00 	movl   $0x20000,0x804128
  801b02:	00 02 00 
		spaces[0].isFree = 1;
  801b05:	c7 05 2c 41 80 00 01 	movl   $0x1,0x80412c
  801b0c:	00 00 00 
		arraySize++;
  801b0f:	a1 28 40 80 00       	mov    0x804028,%eax
  801b14:	40                   	inc    %eax
  801b15:	a3 28 40 80 00       	mov    %eax,0x804028
	}
	int min_diff = numPages + 1;
  801b1a:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  801b21:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  801b28:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801b2f:	8b 55 08             	mov    0x8(%ebp),%edx
  801b32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b35:	01 d0                	add    %edx,%eax
  801b37:	48                   	dec    %eax
  801b38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b43:	f7 75 e8             	divl   -0x18(%ebp)
  801b46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b49:	29 d0                	sub    %edx,%eax
  801b4b:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	c1 e8 0c             	shr    $0xc,%eax
  801b54:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  801b57:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801b5e:	eb 57                	jmp    801bb7 <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  801b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b63:	c1 e0 04             	shl    $0x4,%eax
  801b66:	05 2c 41 80 00       	add    $0x80412c,%eax
  801b6b:	8b 00                	mov    (%eax),%eax
  801b6d:	85 c0                	test   %eax,%eax
  801b6f:	74 42                	je     801bb3 <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  801b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b74:	c1 e0 04             	shl    $0x4,%eax
  801b77:	05 28 41 80 00       	add    $0x804128,%eax
  801b7c:	8b 00                	mov    (%eax),%eax
  801b7e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801b81:	7c 31                	jl     801bb4 <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  801b83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b86:	c1 e0 04             	shl    $0x4,%eax
  801b89:	05 28 41 80 00       	add    $0x804128,%eax
  801b8e:	8b 00                	mov    (%eax),%eax
  801b90:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801b93:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b96:	7d 1c                	jge    801bb4 <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  801b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b9b:	c1 e0 04             	shl    $0x4,%eax
  801b9e:	05 28 41 80 00       	add    $0x804128,%eax
  801ba3:	8b 00                	mov    (%eax),%eax
  801ba5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  801bab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bb1:	eb 01                	jmp    801bb4 <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801bb3:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  801bb4:	ff 45 ec             	incl   -0x14(%ebp)
  801bb7:	a1 28 40 80 00       	mov    0x804028,%eax
  801bbc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801bbf:	7c 9f                	jl     801b60 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  801bc1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801bc5:	75 0a                	jne    801bd1 <malloc+0xf9>
	{
		return NULL;
  801bc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcc:	e9 34 01 00 00       	jmp    801d05 <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  801bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd4:	c1 e0 04             	shl    $0x4,%eax
  801bd7:	05 28 41 80 00       	add    $0x804128,%eax
  801bdc:	8b 00                	mov    (%eax),%eax
  801bde:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801be1:	75 38                	jne    801c1b <malloc+0x143>
		{
			spaces[index].isFree = 0;
  801be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be6:	c1 e0 04             	shl    $0x4,%eax
  801be9:	05 2c 41 80 00       	add    $0x80412c,%eax
  801bee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  801bf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bf7:	c1 e0 0c             	shl    $0xc,%eax
  801bfa:	89 c2                	mov    %eax,%edx
  801bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bff:	c1 e0 04             	shl    $0x4,%eax
  801c02:	05 20 41 80 00       	add    $0x804120,%eax
  801c07:	8b 00                	mov    (%eax),%eax
  801c09:	83 ec 08             	sub    $0x8,%esp
  801c0c:	52                   	push   %edx
  801c0d:	50                   	push   %eax
  801c0e:	e8 01 06 00 00       	call   802214 <sys_allocateMem>
  801c13:	83 c4 10             	add    $0x10,%esp
  801c16:	e9 dd 00 00 00       	jmp    801cf8 <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  801c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1e:	c1 e0 04             	shl    $0x4,%eax
  801c21:	05 20 41 80 00       	add    $0x804120,%eax
  801c26:	8b 00                	mov    (%eax),%eax
  801c28:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c2b:	c1 e2 0c             	shl    $0xc,%edx
  801c2e:	01 d0                	add    %edx,%eax
  801c30:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  801c33:	a1 28 40 80 00       	mov    0x804028,%eax
  801c38:	c1 e0 04             	shl    $0x4,%eax
  801c3b:	8d 90 20 41 80 00    	lea    0x804120(%eax),%edx
  801c41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c44:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  801c46:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4f:	c1 e0 04             	shl    $0x4,%eax
  801c52:	05 24 41 80 00       	add    $0x804124,%eax
  801c57:	8b 00                	mov    (%eax),%eax
  801c59:	c1 e2 04             	shl    $0x4,%edx
  801c5c:	81 c2 24 41 80 00    	add    $0x804124,%edx
  801c62:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  801c64:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6d:	c1 e0 04             	shl    $0x4,%eax
  801c70:	05 28 41 80 00       	add    $0x804128,%eax
  801c75:	8b 00                	mov    (%eax),%eax
  801c77:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801c7a:	c1 e2 04             	shl    $0x4,%edx
  801c7d:	81 c2 28 41 80 00    	add    $0x804128,%edx
  801c83:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  801c85:	a1 28 40 80 00       	mov    0x804028,%eax
  801c8a:	c1 e0 04             	shl    $0x4,%eax
  801c8d:	05 2c 41 80 00       	add    $0x80412c,%eax
  801c92:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  801c98:	a1 28 40 80 00       	mov    0x804028,%eax
  801c9d:	40                   	inc    %eax
  801c9e:	a3 28 40 80 00       	mov    %eax,0x804028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  801ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca6:	c1 e0 04             	shl    $0x4,%eax
  801ca9:	8d 90 24 41 80 00    	lea    0x804124(%eax),%edx
  801caf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cb2:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  801cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb7:	c1 e0 04             	shl    $0x4,%eax
  801cba:	8d 90 28 41 80 00    	lea    0x804128(%eax),%edx
  801cc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cc3:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  801cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc8:	c1 e0 04             	shl    $0x4,%eax
  801ccb:	05 2c 41 80 00       	add    $0x80412c,%eax
  801cd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  801cd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cd9:	c1 e0 0c             	shl    $0xc,%eax
  801cdc:	89 c2                	mov    %eax,%edx
  801cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce1:	c1 e0 04             	shl    $0x4,%eax
  801ce4:	05 20 41 80 00       	add    $0x804120,%eax
  801ce9:	8b 00                	mov    (%eax),%eax
  801ceb:	83 ec 08             	sub    $0x8,%esp
  801cee:	52                   	push   %edx
  801cef:	50                   	push   %eax
  801cf0:	e8 1f 05 00 00       	call   802214 <sys_allocateMem>
  801cf5:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  801cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfb:	c1 e0 04             	shl    $0x4,%eax
  801cfe:	05 20 41 80 00       	add    $0x804120,%eax
  801d03:	8b 00                	mov    (%eax),%eax
	}


}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  801d0d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  801d14:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801d1b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801d22:	eb 3f                	jmp    801d63 <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  801d24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d27:	c1 e0 04             	shl    $0x4,%eax
  801d2a:	05 20 41 80 00       	add    $0x804120,%eax
  801d2f:	8b 00                	mov    (%eax),%eax
  801d31:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d34:	75 2a                	jne    801d60 <free+0x59>
		{
			index=i;
  801d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  801d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d3f:	c1 e0 04             	shl    $0x4,%eax
  801d42:	05 28 41 80 00       	add    $0x804128,%eax
  801d47:	8b 00                	mov    (%eax),%eax
  801d49:	c1 e0 0c             	shl    $0xc,%eax
  801d4c:	89 c2                	mov    %eax,%edx
  801d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d51:	83 ec 08             	sub    $0x8,%esp
  801d54:	52                   	push   %edx
  801d55:	50                   	push   %eax
  801d56:	e8 9d 04 00 00       	call   8021f8 <sys_freeMem>
  801d5b:	83 c4 10             	add    $0x10,%esp
			break;
  801d5e:	eb 0d                	jmp    801d6d <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  801d60:	ff 45 ec             	incl   -0x14(%ebp)
  801d63:	a1 28 40 80 00       	mov    0x804028,%eax
  801d68:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801d6b:	7c b7                	jl     801d24 <free+0x1d>
			break;
		}

	}

	if(index == -1)
  801d6d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801d71:	75 17                	jne    801d8a <free+0x83>
	{
		panic("Error");
  801d73:	83 ec 04             	sub    $0x4,%esp
  801d76:	68 e4 30 80 00       	push   $0x8030e4
  801d7b:	68 81 00 00 00       	push   $0x81
  801d80:	68 ea 30 80 00       	push   $0x8030ea
  801d85:	e8 1c eb ff ff       	call   8008a6 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  801d8a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801d91:	e9 cc 00 00 00       	jmp    801e62 <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  801d96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d99:	c1 e0 04             	shl    $0x4,%eax
  801d9c:	05 2c 41 80 00       	add    $0x80412c,%eax
  801da1:	8b 00                	mov    (%eax),%eax
  801da3:	85 c0                	test   %eax,%eax
  801da5:	0f 84 b3 00 00 00    	je     801e5e <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	c1 e0 04             	shl    $0x4,%eax
  801db1:	05 20 41 80 00       	add    $0x804120,%eax
  801db6:	8b 10                	mov    (%eax),%edx
  801db8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dbb:	c1 e0 04             	shl    $0x4,%eax
  801dbe:	05 24 41 80 00       	add    $0x804124,%eax
  801dc3:	8b 00                	mov    (%eax),%eax
  801dc5:	39 c2                	cmp    %eax,%edx
  801dc7:	0f 85 92 00 00 00    	jne    801e5f <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  801dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd0:	c1 e0 04             	shl    $0x4,%eax
  801dd3:	05 24 41 80 00       	add    $0x804124,%eax
  801dd8:	8b 00                	mov    (%eax),%eax
  801dda:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ddd:	c1 e2 04             	shl    $0x4,%edx
  801de0:	81 c2 24 41 80 00    	add    $0x804124,%edx
  801de6:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801de8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801deb:	c1 e0 04             	shl    $0x4,%eax
  801dee:	05 28 41 80 00       	add    $0x804128,%eax
  801df3:	8b 10                	mov    (%eax),%edx
  801df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df8:	c1 e0 04             	shl    $0x4,%eax
  801dfb:	05 28 41 80 00       	add    $0x804128,%eax
  801e00:	8b 00                	mov    (%eax),%eax
  801e02:	01 c2                	add    %eax,%edx
  801e04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e07:	c1 e0 04             	shl    $0x4,%eax
  801e0a:	05 28 41 80 00       	add    $0x804128,%eax
  801e0f:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e14:	c1 e0 04             	shl    $0x4,%eax
  801e17:	05 20 41 80 00       	add    $0x804120,%eax
  801e1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e25:	c1 e0 04             	shl    $0x4,%eax
  801e28:	05 24 41 80 00       	add    $0x804124,%eax
  801e2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e36:	c1 e0 04             	shl    $0x4,%eax
  801e39:	05 28 41 80 00       	add    $0x804128,%eax
  801e3e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e47:	c1 e0 04             	shl    $0x4,%eax
  801e4a:	05 2c 41 80 00       	add    $0x80412c,%eax
  801e4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801e55:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801e5c:	eb 12                	jmp    801e70 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801e5e:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801e5f:	ff 45 e8             	incl   -0x18(%ebp)
  801e62:	a1 28 40 80 00       	mov    0x804028,%eax
  801e67:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801e6a:	0f 8c 26 ff ff ff    	jl     801d96 <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801e70:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801e77:	e9 cc 00 00 00       	jmp    801f48 <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  801e7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e7f:	c1 e0 04             	shl    $0x4,%eax
  801e82:	05 2c 41 80 00       	add    $0x80412c,%eax
  801e87:	8b 00                	mov    (%eax),%eax
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	0f 84 b3 00 00 00    	je     801f44 <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  801e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e94:	c1 e0 04             	shl    $0x4,%eax
  801e97:	05 24 41 80 00       	add    $0x804124,%eax
  801e9c:	8b 10                	mov    (%eax),%edx
  801e9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ea1:	c1 e0 04             	shl    $0x4,%eax
  801ea4:	05 20 41 80 00       	add    $0x804120,%eax
  801ea9:	8b 00                	mov    (%eax),%eax
  801eab:	39 c2                	cmp    %eax,%edx
  801ead:	0f 85 92 00 00 00    	jne    801f45 <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  801eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb6:	c1 e0 04             	shl    $0x4,%eax
  801eb9:	05 20 41 80 00       	add    $0x804120,%eax
  801ebe:	8b 00                	mov    (%eax),%eax
  801ec0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ec3:	c1 e2 04             	shl    $0x4,%edx
  801ec6:	81 c2 20 41 80 00    	add    $0x804120,%edx
  801ecc:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801ece:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ed1:	c1 e0 04             	shl    $0x4,%eax
  801ed4:	05 28 41 80 00       	add    $0x804128,%eax
  801ed9:	8b 10                	mov    (%eax),%edx
  801edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ede:	c1 e0 04             	shl    $0x4,%eax
  801ee1:	05 28 41 80 00       	add    $0x804128,%eax
  801ee6:	8b 00                	mov    (%eax),%eax
  801ee8:	01 c2                	add    %eax,%edx
  801eea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eed:	c1 e0 04             	shl    $0x4,%eax
  801ef0:	05 28 41 80 00       	add    $0x804128,%eax
  801ef5:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	c1 e0 04             	shl    $0x4,%eax
  801efd:	05 20 41 80 00       	add    $0x804120,%eax
  801f02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0b:	c1 e0 04             	shl    $0x4,%eax
  801f0e:	05 24 41 80 00       	add    $0x804124,%eax
  801f13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1c:	c1 e0 04             	shl    $0x4,%eax
  801f1f:	05 28 41 80 00       	add    $0x804128,%eax
  801f24:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2d:	c1 e0 04             	shl    $0x4,%eax
  801f30:	05 2c 41 80 00       	add    $0x80412c,%eax
  801f35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801f3b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801f42:	eb 12                	jmp    801f56 <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801f44:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801f45:	ff 45 e4             	incl   -0x1c(%ebp)
  801f48:	a1 28 40 80 00       	mov    0x804028,%eax
  801f4d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f50:	0f 8c 26 ff ff ff    	jl     801e7c <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  801f56:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801f5a:	75 11                	jne    801f6d <free+0x266>
	{
		spaces[index].isFree = 1;
  801f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5f:	c1 e0 04             	shl    $0x4,%eax
  801f62:	05 2c 41 80 00       	add    $0x80412c,%eax
  801f67:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  801f6d:	90                   	nop
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 18             	sub    $0x18,%esp
  801f76:	8b 45 10             	mov    0x10(%ebp),%eax
  801f79:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801f7c:	83 ec 04             	sub    $0x4,%esp
  801f7f:	68 f8 30 80 00       	push   $0x8030f8
  801f84:	68 b9 00 00 00       	push   $0xb9
  801f89:	68 ea 30 80 00       	push   $0x8030ea
  801f8e:	e8 13 e9 ff ff       	call   8008a6 <_panic>

00801f93 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f99:	83 ec 04             	sub    $0x4,%esp
  801f9c:	68 f8 30 80 00       	push   $0x8030f8
  801fa1:	68 bf 00 00 00       	push   $0xbf
  801fa6:	68 ea 30 80 00       	push   $0x8030ea
  801fab:	e8 f6 e8 ff ff       	call   8008a6 <_panic>

00801fb0 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fb6:	83 ec 04             	sub    $0x4,%esp
  801fb9:	68 f8 30 80 00       	push   $0x8030f8
  801fbe:	68 c5 00 00 00       	push   $0xc5
  801fc3:	68 ea 30 80 00       	push   $0x8030ea
  801fc8:	e8 d9 e8 ff ff       	call   8008a6 <_panic>

00801fcd <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fd3:	83 ec 04             	sub    $0x4,%esp
  801fd6:	68 f8 30 80 00       	push   $0x8030f8
  801fdb:	68 ca 00 00 00       	push   $0xca
  801fe0:	68 ea 30 80 00       	push   $0x8030ea
  801fe5:	e8 bc e8 ff ff       	call   8008a6 <_panic>

00801fea <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ff0:	83 ec 04             	sub    $0x4,%esp
  801ff3:	68 f8 30 80 00       	push   $0x8030f8
  801ff8:	68 d0 00 00 00       	push   $0xd0
  801ffd:	68 ea 30 80 00       	push   $0x8030ea
  802002:	e8 9f e8 ff ff       	call   8008a6 <_panic>

00802007 <shrink>:
}
void shrink(uint32 newSize)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80200d:	83 ec 04             	sub    $0x4,%esp
  802010:	68 f8 30 80 00       	push   $0x8030f8
  802015:	68 d4 00 00 00       	push   $0xd4
  80201a:	68 ea 30 80 00       	push   $0x8030ea
  80201f:	e8 82 e8 ff ff       	call   8008a6 <_panic>

00802024 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	68 f8 30 80 00       	push   $0x8030f8
  802032:	68 d9 00 00 00       	push   $0xd9
  802037:	68 ea 30 80 00       	push   $0x8030ea
  80203c:	e8 65 e8 ff ff       	call   8008a6 <_panic>

00802041 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	57                   	push   %edi
  802045:	56                   	push   %esi
  802046:	53                   	push   %ebx
  802047:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802050:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802053:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802056:	8b 7d 18             	mov    0x18(%ebp),%edi
  802059:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80205c:	cd 30                	int    $0x30
  80205e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802061:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802064:	83 c4 10             	add    $0x10,%esp
  802067:	5b                   	pop    %ebx
  802068:	5e                   	pop    %esi
  802069:	5f                   	pop    %edi
  80206a:	5d                   	pop    %ebp
  80206b:	c3                   	ret    

0080206c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 04             	sub    $0x4,%esp
  802072:	8b 45 10             	mov    0x10(%ebp),%eax
  802075:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802078:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	52                   	push   %edx
  802084:	ff 75 0c             	pushl  0xc(%ebp)
  802087:	50                   	push   %eax
  802088:	6a 00                	push   $0x0
  80208a:	e8 b2 ff ff ff       	call   802041 <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
}
  802092:	90                   	nop
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <sys_cgetc>:

int
sys_cgetc(void)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 01                	push   $0x1
  8020a4:	e8 98 ff ff ff       	call   802041 <syscall>
  8020a9:	83 c4 18             	add    $0x18,%esp
}
  8020ac:	c9                   	leave  
  8020ad:	c3                   	ret    

008020ae <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	50                   	push   %eax
  8020bd:	6a 05                	push   $0x5
  8020bf:	e8 7d ff ff ff       	call   802041 <syscall>
  8020c4:	83 c4 18             	add    $0x18,%esp
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 02                	push   $0x2
  8020d8:	e8 64 ff ff ff       	call   802041 <syscall>
  8020dd:	83 c4 18             	add    $0x18,%esp
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 03                	push   $0x3
  8020f1:	e8 4b ff ff ff       	call   802041 <syscall>
  8020f6:	83 c4 18             	add    $0x18,%esp
}
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 04                	push   $0x4
  80210a:	e8 32 ff ff ff       	call   802041 <syscall>
  80210f:	83 c4 18             	add    $0x18,%esp
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <sys_env_exit>:


void sys_env_exit(void)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 06                	push   $0x6
  802123:	e8 19 ff ff ff       	call   802041 <syscall>
  802128:	83 c4 18             	add    $0x18,%esp
}
  80212b:	90                   	nop
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802131:	8b 55 0c             	mov    0xc(%ebp),%edx
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	52                   	push   %edx
  80213e:	50                   	push   %eax
  80213f:	6a 07                	push   $0x7
  802141:	e8 fb fe ff ff       	call   802041 <syscall>
  802146:	83 c4 18             	add    $0x18,%esp
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	56                   	push   %esi
  80214f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802150:	8b 75 18             	mov    0x18(%ebp),%esi
  802153:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802156:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802159:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	56                   	push   %esi
  802160:	53                   	push   %ebx
  802161:	51                   	push   %ecx
  802162:	52                   	push   %edx
  802163:	50                   	push   %eax
  802164:	6a 08                	push   $0x8
  802166:	e8 d6 fe ff ff       	call   802041 <syscall>
  80216b:	83 c4 18             	add    $0x18,%esp
}
  80216e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802171:	5b                   	pop    %ebx
  802172:	5e                   	pop    %esi
  802173:	5d                   	pop    %ebp
  802174:	c3                   	ret    

00802175 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802178:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	52                   	push   %edx
  802185:	50                   	push   %eax
  802186:	6a 09                	push   $0x9
  802188:	e8 b4 fe ff ff       	call   802041 <syscall>
  80218d:	83 c4 18             	add    $0x18,%esp
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	ff 75 0c             	pushl  0xc(%ebp)
  80219e:	ff 75 08             	pushl  0x8(%ebp)
  8021a1:	6a 0a                	push   $0xa
  8021a3:	e8 99 fe ff ff       	call   802041 <syscall>
  8021a8:	83 c4 18             	add    $0x18,%esp
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 0b                	push   $0xb
  8021bc:	e8 80 fe ff ff       	call   802041 <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 0c                	push   $0xc
  8021d5:	e8 67 fe ff ff       	call   802041 <syscall>
  8021da:	83 c4 18             	add    $0x18,%esp
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 0d                	push   $0xd
  8021ee:	e8 4e fe ff ff       	call   802041 <syscall>
  8021f3:	83 c4 18             	add    $0x18,%esp
}
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	ff 75 0c             	pushl  0xc(%ebp)
  802204:	ff 75 08             	pushl  0x8(%ebp)
  802207:	6a 11                	push   $0x11
  802209:	e8 33 fe ff ff       	call   802041 <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
	return;
  802211:	90                   	nop
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	ff 75 0c             	pushl  0xc(%ebp)
  802220:	ff 75 08             	pushl  0x8(%ebp)
  802223:	6a 12                	push   $0x12
  802225:	e8 17 fe ff ff       	call   802041 <syscall>
  80222a:	83 c4 18             	add    $0x18,%esp
	return ;
  80222d:	90                   	nop
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 0e                	push   $0xe
  80223f:	e8 fd fd ff ff       	call   802041 <syscall>
  802244:	83 c4 18             	add    $0x18,%esp
}
  802247:	c9                   	leave  
  802248:	c3                   	ret    

00802249 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	ff 75 08             	pushl  0x8(%ebp)
  802257:	6a 0f                	push   $0xf
  802259:	e8 e3 fd ff ff       	call   802041 <syscall>
  80225e:	83 c4 18             	add    $0x18,%esp
}
  802261:	c9                   	leave  
  802262:	c3                   	ret    

00802263 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 10                	push   $0x10
  802272:	e8 ca fd ff ff       	call   802041 <syscall>
  802277:	83 c4 18             	add    $0x18,%esp
}
  80227a:	90                   	nop
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 14                	push   $0x14
  80228c:	e8 b0 fd ff ff       	call   802041 <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
}
  802294:	90                   	nop
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 15                	push   $0x15
  8022a6:	e8 96 fd ff ff       	call   802041 <syscall>
  8022ab:	83 c4 18             	add    $0x18,%esp
}
  8022ae:	90                   	nop
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	83 ec 04             	sub    $0x4,%esp
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022bd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	50                   	push   %eax
  8022ca:	6a 16                	push   $0x16
  8022cc:	e8 70 fd ff ff       	call   802041 <syscall>
  8022d1:	83 c4 18             	add    $0x18,%esp
}
  8022d4:	90                   	nop
  8022d5:	c9                   	leave  
  8022d6:	c3                   	ret    

008022d7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 17                	push   $0x17
  8022e6:	e8 56 fd ff ff       	call   802041 <syscall>
  8022eb:	83 c4 18             	add    $0x18,%esp
}
  8022ee:	90                   	nop
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    

008022f1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	ff 75 0c             	pushl  0xc(%ebp)
  802300:	50                   	push   %eax
  802301:	6a 18                	push   $0x18
  802303:	e8 39 fd ff ff       	call   802041 <syscall>
  802308:	83 c4 18             	add    $0x18,%esp
}
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802310:	8b 55 0c             	mov    0xc(%ebp),%edx
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	52                   	push   %edx
  80231d:	50                   	push   %eax
  80231e:	6a 1b                	push   $0x1b
  802320:	e8 1c fd ff ff       	call   802041 <syscall>
  802325:	83 c4 18             	add    $0x18,%esp
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80232d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	52                   	push   %edx
  80233a:	50                   	push   %eax
  80233b:	6a 19                	push   $0x19
  80233d:	e8 ff fc ff ff       	call   802041 <syscall>
  802342:	83 c4 18             	add    $0x18,%esp
}
  802345:	90                   	nop
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80234b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	52                   	push   %edx
  802358:	50                   	push   %eax
  802359:	6a 1a                	push   $0x1a
  80235b:	e8 e1 fc ff ff       	call   802041 <syscall>
  802360:	83 c4 18             	add    $0x18,%esp
}
  802363:	90                   	nop
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
  802369:	83 ec 04             	sub    $0x4,%esp
  80236c:	8b 45 10             	mov    0x10(%ebp),%eax
  80236f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802372:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802375:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	6a 00                	push   $0x0
  80237e:	51                   	push   %ecx
  80237f:	52                   	push   %edx
  802380:	ff 75 0c             	pushl  0xc(%ebp)
  802383:	50                   	push   %eax
  802384:	6a 1c                	push   $0x1c
  802386:	e8 b6 fc ff ff       	call   802041 <syscall>
  80238b:	83 c4 18             	add    $0x18,%esp
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802393:	8b 55 0c             	mov    0xc(%ebp),%edx
  802396:	8b 45 08             	mov    0x8(%ebp),%eax
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	52                   	push   %edx
  8023a0:	50                   	push   %eax
  8023a1:	6a 1d                	push   $0x1d
  8023a3:	e8 99 fc ff ff       	call   802041 <syscall>
  8023a8:	83 c4 18             	add    $0x18,%esp
}
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    

008023ad <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	51                   	push   %ecx
  8023be:	52                   	push   %edx
  8023bf:	50                   	push   %eax
  8023c0:	6a 1e                	push   $0x1e
  8023c2:	e8 7a fc ff ff       	call   802041 <syscall>
  8023c7:	83 c4 18             	add    $0x18,%esp
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	52                   	push   %edx
  8023dc:	50                   	push   %eax
  8023dd:	6a 1f                	push   $0x1f
  8023df:	e8 5d fc ff ff       	call   802041 <syscall>
  8023e4:	83 c4 18             	add    $0x18,%esp
}
  8023e7:	c9                   	leave  
  8023e8:	c3                   	ret    

008023e9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 20                	push   $0x20
  8023f8:	e8 44 fc ff ff       	call   802041 <syscall>
  8023fd:	83 c4 18             	add    $0x18,%esp
}
  802400:	c9                   	leave  
  802401:	c3                   	ret    

00802402 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	6a 00                	push   $0x0
  80240a:	ff 75 14             	pushl  0x14(%ebp)
  80240d:	ff 75 10             	pushl  0x10(%ebp)
  802410:	ff 75 0c             	pushl  0xc(%ebp)
  802413:	50                   	push   %eax
  802414:	6a 21                	push   $0x21
  802416:	e8 26 fc ff ff       	call   802041 <syscall>
  80241b:	83 c4 18             	add    $0x18,%esp
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802423:	8b 45 08             	mov    0x8(%ebp),%eax
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	50                   	push   %eax
  80242f:	6a 22                	push   $0x22
  802431:	e8 0b fc ff ff       	call   802041 <syscall>
  802436:	83 c4 18             	add    $0x18,%esp
}
  802439:	90                   	nop
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	50                   	push   %eax
  80244b:	6a 23                	push   $0x23
  80244d:	e8 ef fb ff ff       	call   802041 <syscall>
  802452:	83 c4 18             	add    $0x18,%esp
}
  802455:	90                   	nop
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80245e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802461:	8d 50 04             	lea    0x4(%eax),%edx
  802464:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	52                   	push   %edx
  80246e:	50                   	push   %eax
  80246f:	6a 24                	push   $0x24
  802471:	e8 cb fb ff ff       	call   802041 <syscall>
  802476:	83 c4 18             	add    $0x18,%esp
	return result;
  802479:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80247c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80247f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802482:	89 01                	mov    %eax,(%ecx)
  802484:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802487:	8b 45 08             	mov    0x8(%ebp),%eax
  80248a:	c9                   	leave  
  80248b:	c2 04 00             	ret    $0x4

0080248e <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	ff 75 10             	pushl  0x10(%ebp)
  802498:	ff 75 0c             	pushl  0xc(%ebp)
  80249b:	ff 75 08             	pushl  0x8(%ebp)
  80249e:	6a 13                	push   $0x13
  8024a0:	e8 9c fb ff ff       	call   802041 <syscall>
  8024a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a8:	90                   	nop
}
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <sys_rcr2>:
uint32 sys_rcr2()
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 25                	push   $0x25
  8024ba:	e8 82 fb ff ff       	call   802041 <syscall>
  8024bf:	83 c4 18             	add    $0x18,%esp
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	83 ec 04             	sub    $0x4,%esp
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024d0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	50                   	push   %eax
  8024dd:	6a 26                	push   $0x26
  8024df:	e8 5d fb ff ff       	call   802041 <syscall>
  8024e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e7:	90                   	nop
}
  8024e8:	c9                   	leave  
  8024e9:	c3                   	ret    

008024ea <rsttst>:
void rsttst()
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 28                	push   $0x28
  8024f9:	e8 43 fb ff ff       	call   802041 <syscall>
  8024fe:	83 c4 18             	add    $0x18,%esp
	return ;
  802501:	90                   	nop
}
  802502:	c9                   	leave  
  802503:	c3                   	ret    

00802504 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
  802507:	83 ec 04             	sub    $0x4,%esp
  80250a:	8b 45 14             	mov    0x14(%ebp),%eax
  80250d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802510:	8b 55 18             	mov    0x18(%ebp),%edx
  802513:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802517:	52                   	push   %edx
  802518:	50                   	push   %eax
  802519:	ff 75 10             	pushl  0x10(%ebp)
  80251c:	ff 75 0c             	pushl  0xc(%ebp)
  80251f:	ff 75 08             	pushl  0x8(%ebp)
  802522:	6a 27                	push   $0x27
  802524:	e8 18 fb ff ff       	call   802041 <syscall>
  802529:	83 c4 18             	add    $0x18,%esp
	return ;
  80252c:	90                   	nop
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <chktst>:
void chktst(uint32 n)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	ff 75 08             	pushl  0x8(%ebp)
  80253d:	6a 29                	push   $0x29
  80253f:	e8 fd fa ff ff       	call   802041 <syscall>
  802544:	83 c4 18             	add    $0x18,%esp
	return ;
  802547:	90                   	nop
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <inctst>:

void inctst()
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 2a                	push   $0x2a
  802559:	e8 e3 fa ff ff       	call   802041 <syscall>
  80255e:	83 c4 18             	add    $0x18,%esp
	return ;
  802561:	90                   	nop
}
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <gettst>:
uint32 gettst()
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 00                	push   $0x0
  80256f:	6a 00                	push   $0x0
  802571:	6a 2b                	push   $0x2b
  802573:	e8 c9 fa ff ff       	call   802041 <syscall>
  802578:	83 c4 18             	add    $0x18,%esp
}
  80257b:	c9                   	leave  
  80257c:	c3                   	ret    

0080257d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
  802580:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	6a 2c                	push   $0x2c
  80258f:	e8 ad fa ff ff       	call   802041 <syscall>
  802594:	83 c4 18             	add    $0x18,%esp
  802597:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80259a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80259e:	75 07                	jne    8025a7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a5:	eb 05                	jmp    8025ac <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ac:	c9                   	leave  
  8025ad:	c3                   	ret    

008025ae <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
  8025b1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 2c                	push   $0x2c
  8025c0:	e8 7c fa ff ff       	call   802041 <syscall>
  8025c5:	83 c4 18             	add    $0x18,%esp
  8025c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025cb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025cf:	75 07                	jne    8025d8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d6:	eb 05                	jmp    8025dd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025dd:	c9                   	leave  
  8025de:	c3                   	ret    

008025df <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
  8025e2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 2c                	push   $0x2c
  8025f1:	e8 4b fa ff ff       	call   802041 <syscall>
  8025f6:	83 c4 18             	add    $0x18,%esp
  8025f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025fc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802600:	75 07                	jne    802609 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802602:	b8 01 00 00 00       	mov    $0x1,%eax
  802607:	eb 05                	jmp    80260e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802609:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80260e:	c9                   	leave  
  80260f:	c3                   	ret    

00802610 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802610:	55                   	push   %ebp
  802611:	89 e5                	mov    %esp,%ebp
  802613:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 2c                	push   $0x2c
  802622:	e8 1a fa ff ff       	call   802041 <syscall>
  802627:	83 c4 18             	add    $0x18,%esp
  80262a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80262d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802631:	75 07                	jne    80263a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802633:	b8 01 00 00 00       	mov    $0x1,%eax
  802638:	eb 05                	jmp    80263f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80263a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263f:	c9                   	leave  
  802640:	c3                   	ret    

00802641 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802641:	55                   	push   %ebp
  802642:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802644:	6a 00                	push   $0x0
  802646:	6a 00                	push   $0x0
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	ff 75 08             	pushl  0x8(%ebp)
  80264f:	6a 2d                	push   $0x2d
  802651:	e8 eb f9 ff ff       	call   802041 <syscall>
  802656:	83 c4 18             	add    $0x18,%esp
	return ;
  802659:	90                   	nop
}
  80265a:	c9                   	leave  
  80265b:	c3                   	ret    

0080265c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
  80265f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802660:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802663:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802666:	8b 55 0c             	mov    0xc(%ebp),%edx
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	6a 00                	push   $0x0
  80266e:	53                   	push   %ebx
  80266f:	51                   	push   %ecx
  802670:	52                   	push   %edx
  802671:	50                   	push   %eax
  802672:	6a 2e                	push   $0x2e
  802674:	e8 c8 f9 ff ff       	call   802041 <syscall>
  802679:	83 c4 18             	add    $0x18,%esp
}
  80267c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80267f:	c9                   	leave  
  802680:	c3                   	ret    

00802681 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802681:	55                   	push   %ebp
  802682:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802684:	8b 55 0c             	mov    0xc(%ebp),%edx
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	52                   	push   %edx
  802691:	50                   	push   %eax
  802692:	6a 2f                	push   $0x2f
  802694:	e8 a8 f9 ff ff       	call   802041 <syscall>
  802699:	83 c4 18             	add    $0x18,%esp
}
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    
  80269e:	66 90                	xchg   %ax,%ax

008026a0 <__udivdi3>:
  8026a0:	55                   	push   %ebp
  8026a1:	57                   	push   %edi
  8026a2:	56                   	push   %esi
  8026a3:	53                   	push   %ebx
  8026a4:	83 ec 1c             	sub    $0x1c,%esp
  8026a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8026ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8026af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026b7:	89 ca                	mov    %ecx,%edx
  8026b9:	89 f8                	mov    %edi,%eax
  8026bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8026bf:	85 f6                	test   %esi,%esi
  8026c1:	75 2d                	jne    8026f0 <__udivdi3+0x50>
  8026c3:	39 cf                	cmp    %ecx,%edi
  8026c5:	77 65                	ja     80272c <__udivdi3+0x8c>
  8026c7:	89 fd                	mov    %edi,%ebp
  8026c9:	85 ff                	test   %edi,%edi
  8026cb:	75 0b                	jne    8026d8 <__udivdi3+0x38>
  8026cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d2:	31 d2                	xor    %edx,%edx
  8026d4:	f7 f7                	div    %edi
  8026d6:	89 c5                	mov    %eax,%ebp
  8026d8:	31 d2                	xor    %edx,%edx
  8026da:	89 c8                	mov    %ecx,%eax
  8026dc:	f7 f5                	div    %ebp
  8026de:	89 c1                	mov    %eax,%ecx
  8026e0:	89 d8                	mov    %ebx,%eax
  8026e2:	f7 f5                	div    %ebp
  8026e4:	89 cf                	mov    %ecx,%edi
  8026e6:	89 fa                	mov    %edi,%edx
  8026e8:	83 c4 1c             	add    $0x1c,%esp
  8026eb:	5b                   	pop    %ebx
  8026ec:	5e                   	pop    %esi
  8026ed:	5f                   	pop    %edi
  8026ee:	5d                   	pop    %ebp
  8026ef:	c3                   	ret    
  8026f0:	39 ce                	cmp    %ecx,%esi
  8026f2:	77 28                	ja     80271c <__udivdi3+0x7c>
  8026f4:	0f bd fe             	bsr    %esi,%edi
  8026f7:	83 f7 1f             	xor    $0x1f,%edi
  8026fa:	75 40                	jne    80273c <__udivdi3+0x9c>
  8026fc:	39 ce                	cmp    %ecx,%esi
  8026fe:	72 0a                	jb     80270a <__udivdi3+0x6a>
  802700:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802704:	0f 87 9e 00 00 00    	ja     8027a8 <__udivdi3+0x108>
  80270a:	b8 01 00 00 00       	mov    $0x1,%eax
  80270f:	89 fa                	mov    %edi,%edx
  802711:	83 c4 1c             	add    $0x1c,%esp
  802714:	5b                   	pop    %ebx
  802715:	5e                   	pop    %esi
  802716:	5f                   	pop    %edi
  802717:	5d                   	pop    %ebp
  802718:	c3                   	ret    
  802719:	8d 76 00             	lea    0x0(%esi),%esi
  80271c:	31 ff                	xor    %edi,%edi
  80271e:	31 c0                	xor    %eax,%eax
  802720:	89 fa                	mov    %edi,%edx
  802722:	83 c4 1c             	add    $0x1c,%esp
  802725:	5b                   	pop    %ebx
  802726:	5e                   	pop    %esi
  802727:	5f                   	pop    %edi
  802728:	5d                   	pop    %ebp
  802729:	c3                   	ret    
  80272a:	66 90                	xchg   %ax,%ax
  80272c:	89 d8                	mov    %ebx,%eax
  80272e:	f7 f7                	div    %edi
  802730:	31 ff                	xor    %edi,%edi
  802732:	89 fa                	mov    %edi,%edx
  802734:	83 c4 1c             	add    $0x1c,%esp
  802737:	5b                   	pop    %ebx
  802738:	5e                   	pop    %esi
  802739:	5f                   	pop    %edi
  80273a:	5d                   	pop    %ebp
  80273b:	c3                   	ret    
  80273c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802741:	89 eb                	mov    %ebp,%ebx
  802743:	29 fb                	sub    %edi,%ebx
  802745:	89 f9                	mov    %edi,%ecx
  802747:	d3 e6                	shl    %cl,%esi
  802749:	89 c5                	mov    %eax,%ebp
  80274b:	88 d9                	mov    %bl,%cl
  80274d:	d3 ed                	shr    %cl,%ebp
  80274f:	89 e9                	mov    %ebp,%ecx
  802751:	09 f1                	or     %esi,%ecx
  802753:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802757:	89 f9                	mov    %edi,%ecx
  802759:	d3 e0                	shl    %cl,%eax
  80275b:	89 c5                	mov    %eax,%ebp
  80275d:	89 d6                	mov    %edx,%esi
  80275f:	88 d9                	mov    %bl,%cl
  802761:	d3 ee                	shr    %cl,%esi
  802763:	89 f9                	mov    %edi,%ecx
  802765:	d3 e2                	shl    %cl,%edx
  802767:	8b 44 24 08          	mov    0x8(%esp),%eax
  80276b:	88 d9                	mov    %bl,%cl
  80276d:	d3 e8                	shr    %cl,%eax
  80276f:	09 c2                	or     %eax,%edx
  802771:	89 d0                	mov    %edx,%eax
  802773:	89 f2                	mov    %esi,%edx
  802775:	f7 74 24 0c          	divl   0xc(%esp)
  802779:	89 d6                	mov    %edx,%esi
  80277b:	89 c3                	mov    %eax,%ebx
  80277d:	f7 e5                	mul    %ebp
  80277f:	39 d6                	cmp    %edx,%esi
  802781:	72 19                	jb     80279c <__udivdi3+0xfc>
  802783:	74 0b                	je     802790 <__udivdi3+0xf0>
  802785:	89 d8                	mov    %ebx,%eax
  802787:	31 ff                	xor    %edi,%edi
  802789:	e9 58 ff ff ff       	jmp    8026e6 <__udivdi3+0x46>
  80278e:	66 90                	xchg   %ax,%ax
  802790:	8b 54 24 08          	mov    0x8(%esp),%edx
  802794:	89 f9                	mov    %edi,%ecx
  802796:	d3 e2                	shl    %cl,%edx
  802798:	39 c2                	cmp    %eax,%edx
  80279a:	73 e9                	jae    802785 <__udivdi3+0xe5>
  80279c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80279f:	31 ff                	xor    %edi,%edi
  8027a1:	e9 40 ff ff ff       	jmp    8026e6 <__udivdi3+0x46>
  8027a6:	66 90                	xchg   %ax,%ax
  8027a8:	31 c0                	xor    %eax,%eax
  8027aa:	e9 37 ff ff ff       	jmp    8026e6 <__udivdi3+0x46>
  8027af:	90                   	nop

008027b0 <__umoddi3>:
  8027b0:	55                   	push   %ebp
  8027b1:	57                   	push   %edi
  8027b2:	56                   	push   %esi
  8027b3:	53                   	push   %ebx
  8027b4:	83 ec 1c             	sub    $0x1c,%esp
  8027b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8027bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8027c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027cf:	89 f3                	mov    %esi,%ebx
  8027d1:	89 fa                	mov    %edi,%edx
  8027d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8027d7:	89 34 24             	mov    %esi,(%esp)
  8027da:	85 c0                	test   %eax,%eax
  8027dc:	75 1a                	jne    8027f8 <__umoddi3+0x48>
  8027de:	39 f7                	cmp    %esi,%edi
  8027e0:	0f 86 a2 00 00 00    	jbe    802888 <__umoddi3+0xd8>
  8027e6:	89 c8                	mov    %ecx,%eax
  8027e8:	89 f2                	mov    %esi,%edx
  8027ea:	f7 f7                	div    %edi
  8027ec:	89 d0                	mov    %edx,%eax
  8027ee:	31 d2                	xor    %edx,%edx
  8027f0:	83 c4 1c             	add    $0x1c,%esp
  8027f3:	5b                   	pop    %ebx
  8027f4:	5e                   	pop    %esi
  8027f5:	5f                   	pop    %edi
  8027f6:	5d                   	pop    %ebp
  8027f7:	c3                   	ret    
  8027f8:	39 f0                	cmp    %esi,%eax
  8027fa:	0f 87 ac 00 00 00    	ja     8028ac <__umoddi3+0xfc>
  802800:	0f bd e8             	bsr    %eax,%ebp
  802803:	83 f5 1f             	xor    $0x1f,%ebp
  802806:	0f 84 ac 00 00 00    	je     8028b8 <__umoddi3+0x108>
  80280c:	bf 20 00 00 00       	mov    $0x20,%edi
  802811:	29 ef                	sub    %ebp,%edi
  802813:	89 fe                	mov    %edi,%esi
  802815:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802819:	89 e9                	mov    %ebp,%ecx
  80281b:	d3 e0                	shl    %cl,%eax
  80281d:	89 d7                	mov    %edx,%edi
  80281f:	89 f1                	mov    %esi,%ecx
  802821:	d3 ef                	shr    %cl,%edi
  802823:	09 c7                	or     %eax,%edi
  802825:	89 e9                	mov    %ebp,%ecx
  802827:	d3 e2                	shl    %cl,%edx
  802829:	89 14 24             	mov    %edx,(%esp)
  80282c:	89 d8                	mov    %ebx,%eax
  80282e:	d3 e0                	shl    %cl,%eax
  802830:	89 c2                	mov    %eax,%edx
  802832:	8b 44 24 08          	mov    0x8(%esp),%eax
  802836:	d3 e0                	shl    %cl,%eax
  802838:	89 44 24 04          	mov    %eax,0x4(%esp)
  80283c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802840:	89 f1                	mov    %esi,%ecx
  802842:	d3 e8                	shr    %cl,%eax
  802844:	09 d0                	or     %edx,%eax
  802846:	d3 eb                	shr    %cl,%ebx
  802848:	89 da                	mov    %ebx,%edx
  80284a:	f7 f7                	div    %edi
  80284c:	89 d3                	mov    %edx,%ebx
  80284e:	f7 24 24             	mull   (%esp)
  802851:	89 c6                	mov    %eax,%esi
  802853:	89 d1                	mov    %edx,%ecx
  802855:	39 d3                	cmp    %edx,%ebx
  802857:	0f 82 87 00 00 00    	jb     8028e4 <__umoddi3+0x134>
  80285d:	0f 84 91 00 00 00    	je     8028f4 <__umoddi3+0x144>
  802863:	8b 54 24 04          	mov    0x4(%esp),%edx
  802867:	29 f2                	sub    %esi,%edx
  802869:	19 cb                	sbb    %ecx,%ebx
  80286b:	89 d8                	mov    %ebx,%eax
  80286d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802871:	d3 e0                	shl    %cl,%eax
  802873:	89 e9                	mov    %ebp,%ecx
  802875:	d3 ea                	shr    %cl,%edx
  802877:	09 d0                	or     %edx,%eax
  802879:	89 e9                	mov    %ebp,%ecx
  80287b:	d3 eb                	shr    %cl,%ebx
  80287d:	89 da                	mov    %ebx,%edx
  80287f:	83 c4 1c             	add    $0x1c,%esp
  802882:	5b                   	pop    %ebx
  802883:	5e                   	pop    %esi
  802884:	5f                   	pop    %edi
  802885:	5d                   	pop    %ebp
  802886:	c3                   	ret    
  802887:	90                   	nop
  802888:	89 fd                	mov    %edi,%ebp
  80288a:	85 ff                	test   %edi,%edi
  80288c:	75 0b                	jne    802899 <__umoddi3+0xe9>
  80288e:	b8 01 00 00 00       	mov    $0x1,%eax
  802893:	31 d2                	xor    %edx,%edx
  802895:	f7 f7                	div    %edi
  802897:	89 c5                	mov    %eax,%ebp
  802899:	89 f0                	mov    %esi,%eax
  80289b:	31 d2                	xor    %edx,%edx
  80289d:	f7 f5                	div    %ebp
  80289f:	89 c8                	mov    %ecx,%eax
  8028a1:	f7 f5                	div    %ebp
  8028a3:	89 d0                	mov    %edx,%eax
  8028a5:	e9 44 ff ff ff       	jmp    8027ee <__umoddi3+0x3e>
  8028aa:	66 90                	xchg   %ax,%ax
  8028ac:	89 c8                	mov    %ecx,%eax
  8028ae:	89 f2                	mov    %esi,%edx
  8028b0:	83 c4 1c             	add    $0x1c,%esp
  8028b3:	5b                   	pop    %ebx
  8028b4:	5e                   	pop    %esi
  8028b5:	5f                   	pop    %edi
  8028b6:	5d                   	pop    %ebp
  8028b7:	c3                   	ret    
  8028b8:	3b 04 24             	cmp    (%esp),%eax
  8028bb:	72 06                	jb     8028c3 <__umoddi3+0x113>
  8028bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8028c1:	77 0f                	ja     8028d2 <__umoddi3+0x122>
  8028c3:	89 f2                	mov    %esi,%edx
  8028c5:	29 f9                	sub    %edi,%ecx
  8028c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8028cb:	89 14 24             	mov    %edx,(%esp)
  8028ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8028d6:	8b 14 24             	mov    (%esp),%edx
  8028d9:	83 c4 1c             	add    $0x1c,%esp
  8028dc:	5b                   	pop    %ebx
  8028dd:	5e                   	pop    %esi
  8028de:	5f                   	pop    %edi
  8028df:	5d                   	pop    %ebp
  8028e0:	c3                   	ret    
  8028e1:	8d 76 00             	lea    0x0(%esi),%esi
  8028e4:	2b 04 24             	sub    (%esp),%eax
  8028e7:	19 fa                	sbb    %edi,%edx
  8028e9:	89 d1                	mov    %edx,%ecx
  8028eb:	89 c6                	mov    %eax,%esi
  8028ed:	e9 71 ff ff ff       	jmp    802863 <__umoddi3+0xb3>
  8028f2:	66 90                	xchg   %ax,%ax
  8028f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8028f8:	72 ea                	jb     8028e4 <__umoddi3+0x134>
  8028fa:	89 d9                	mov    %ebx,%ecx
  8028fc:	e9 62 ff ff ff       	jmp    802863 <__umoddi3+0xb3>
