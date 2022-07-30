
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 f7 04 00 00       	call   80052d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 7e 1a 00 00       	call   801ac1 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 a8 1a 00 00       	call   801af3 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80004e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800055:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 e0 24 80 00       	push   $0x8024e0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 1f 19 00 00       	call   80198b <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e4 24 80 00       	push   $0x8024e4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 09 19 00 00       	call   80198b <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 ec 24 80 00       	push   $0x8024ec
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 ec 18 00 00       	call   80198b <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 fa 24 80 00       	push   $0x8024fa
  8000b8:	e8 ab 18 00 00       	call   801968 <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		tmpArray[i] = sharedArray[i];
  8000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	01 c2                	add    %eax,%edx
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e8:	01 c8                	add    %ecx,%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	89 02                	mov    %eax,(%edx)

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	8d 55 b4             	lea    -0x4c(%ebp),%edx
  800106:	52                   	push   %edx
  800107:	8d 55 b8             	lea    -0x48(%ebp),%edx
  80010a:	52                   	push   %edx
  80010b:	8d 55 bc             	lea    -0x44(%ebp),%edx
  80010e:	52                   	push   %edx
  80010f:	8d 55 c0             	lea    -0x40(%ebp),%edx
  800112:	52                   	push   %edx
  800113:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800116:	52                   	push   %edx
  800117:	50                   	push   %eax
  800118:	ff 75 dc             	pushl  -0x24(%ebp)
  80011b:	e8 55 02 00 00       	call   800375 <ArrayStats>
  800120:	83 c4 20             	add    $0x20,%esp
	cprintf("Stats Calculations are Finished!!!!\n") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 04 25 80 00       	push   $0x802504
  80012b:	e8 16 06 00 00       	call   800746 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 29 25 80 00       	push   $0x802529
  80013f:	e8 24 18 00 00       	call   801968 <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 2e 25 80 00       	push   $0x80252e
  80015e:	e8 05 18 00 00       	call   801968 <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 32 25 80 00       	push   $0x802532
  80017d:	e8 e6 17 00 00       	call   801968 <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 36 25 80 00       	push   $0x802536
  80019c:	e8 c7 17 00 00       	call   801968 <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 3a 25 80 00       	push   $0x80253a
  8001bb:	e8 a8 17 00 00       	call   801968 <smalloc>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8001c6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001cc:	89 10                	mov    %edx,(%eax)

	(*finishedCount)++ ;
  8001ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d1:	8b 00                	mov    (%eax),%eax
  8001d3:	8d 50 01             	lea    0x1(%eax),%edx
  8001d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)

}
  8001db:	90                   	nop
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  8001e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8001ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ed:	48                   	dec    %eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	52                   	push   %edx
  8001f2:	50                   	push   %eax
  8001f3:	6a 00                	push   $0x0
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 05 00 00 00       	call   800205 <QSort>
  800200:	83 c4 20             	add    $0x20,%esp
}
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  80020b:	8b 45 10             	mov    0x10(%ebp),%eax
  80020e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800211:	7c 16                	jl     800229 <QSort+0x24>
  800213:	8b 45 14             	mov    0x14(%ebp),%eax
  800216:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021d:	8b 45 08             	mov    0x8(%ebp),%eax
  800220:	01 d0                	add    %edx,%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	e9 4a 01 00 00       	jmp    800373 <QSort+0x16e>

	int pvtIndex = RAND(startIndex, finalIndex) ;
  800229:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	50                   	push   %eax
  800230:	e8 1b 1c 00 00       	call   801e50 <sys_get_virtual_time>
  800235:	83 c4 0c             	add    $0xc,%esp
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 55 14             	mov    0x14(%ebp),%edx
  80023e:	2b 55 10             	sub    0x10(%ebp),%edx
  800241:	89 d1                	mov    %edx,%ecx
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 f1                	div    %ecx
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	ff 75 ec             	pushl  -0x14(%ebp)
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	e8 77 02 00 00       	call   8004da <Swap>
  800263:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  800266:	8b 45 10             	mov    0x10(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80026d:	8b 45 14             	mov    0x14(%ebp),%eax
  800270:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800273:	e9 80 00 00 00       	jmp    8002f8 <QSort+0xf3>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800278:	ff 45 f4             	incl   -0xc(%ebp)
  80027b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	7f 2b                	jg     8002ae <QSort+0xa9>
  800283:	8b 45 10             	mov    0x10(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 10                	mov    (%eax),%edx
  800294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800297:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	01 c8                	add    %ecx,%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	39 c2                	cmp    %eax,%edx
  8002a7:	7d cf                	jge    800278 <QSort+0x73>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002a9:	eb 03                	jmp    8002ae <QSort+0xa9>
  8002ab:	ff 4d f0             	decl   -0x10(%ebp)
  8002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002b4:	7e 26                	jle    8002dc <QSort+0xd7>
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	01 c8                	add    %ecx,%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	7e cf                	jle    8002ab <QSort+0xa6>

		if (i <= j)
  8002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e2:	7f 14                	jg     8002f8 <QSort+0xf3>
		{
			Swap(Elements, i, j);
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8002ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ed:	ff 75 08             	pushl  0x8(%ebp)
  8002f0:	e8 e5 01 00 00       	call   8004da <Swap>
  8002f5:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8002f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002fe:	0f 8e 77 ff ff ff    	jle    80027b <QSort+0x76>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 f0             	pushl  -0x10(%ebp)
  80030a:	ff 75 10             	pushl  0x10(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 c5 01 00 00       	call   8004da <Swap>
  800315:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  800318:	8b 45 18             	mov    0x18(%ebp),%eax
  80031b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031e:	75 13                	jne    800333 <QSort+0x12e>
		return Elements[kIndex] ;
  800320:	8b 45 18             	mov    0x18(%ebp),%eax
  800323:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	eb 40                	jmp    800373 <QSort+0x16e>
	else if (kIndex < j)
  800333:	8b 45 18             	mov    0x18(%ebp),%eax
  800336:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800339:	7d 1e                	jge    800359 <QSort+0x154>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  80033b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033e:	48                   	dec    %eax
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 18             	pushl  0x18(%ebp)
  800345:	50                   	push   %eax
  800346:	ff 75 10             	pushl  0x10(%ebp)
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 b1 fe ff ff       	call   800205 <QSort>
  800354:	83 c4 20             	add    $0x20,%esp
  800357:	eb 1a                	jmp    800373 <QSort+0x16e>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	ff 75 18             	pushl  0x18(%ebp)
  80035f:	ff 75 14             	pushl  0x14(%ebp)
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	ff 75 0c             	pushl  0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 95 fe ff ff       	call   800205 <QSort>
  800370:	83 c4 20             	add    $0x20,%esp
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	53                   	push   %ebx
  800379:	83 ec 14             	sub    $0x14,%esp
	int i ;
	*mean =0 ;
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*min = 0x7FFFFFFF ;
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  80038e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800391:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80039e:	e9 80 00 00 00       	jmp    800423 <ArrayStats+0xae>
	{
		(*mean) += Elements[i];
  8003a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a6:	8b 10                	mov    (%eax),%edx
  8003a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	01 c8                	add    %ecx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	01 c2                	add    %eax,%edx
  8003bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003be:	89 10                	mov    %edx,(%eax)
		if (Elements[i] < (*min))
  8003c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	8b 10                	mov    (%eax),%edx
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	7d 16                	jge    8003f0 <ArrayStats+0x7b>
		{
			(*min) = Elements[i];
  8003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  8003f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	8b 10                	mov    (%eax),%edx
  800401:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	7e 16                	jle    800420 <ArrayStats+0xab>
		{
			(*max) = Elements[i];
  80040a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80040d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	01 d0                	add    %edx,%eax
  800419:	8b 10                	mov    (%eax),%edx
  80041b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80041e:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 f4             	incl   -0xc(%ebp)
  800423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	0f 8c 74 ff ff ff    	jl     8003a3 <ArrayStats+0x2e>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);
  80042f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800432:	89 c2                	mov    %eax,%edx
  800434:	c1 ea 1f             	shr    $0x1f,%edx
  800437:	01 d0                	add    %edx,%eax
  800439:	d1 f8                	sar    %eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	50                   	push   %eax
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 08             	pushl  0x8(%ebp)
  800445:	e8 94 fd ff ff       	call   8001de <KthElement>
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	8b 45 20             	mov    0x20(%ebp),%eax
  800452:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  800454:	8b 45 10             	mov    0x10(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	99                   	cltd   
  80045a:	f7 7d 0c             	idivl  0xc(%ebp)
  80045d:	89 c2                	mov    %eax,%edx
  80045f:	8b 45 10             	mov    0x10(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
	(*var) = 0;
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80046d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800474:	eb 46                	jmp    8004bc <ArrayStats+0x147>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8b 10                	mov    (%eax),%edx
  80047b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c8                	add    %ecx,%eax
  80048a:	8b 08                	mov    (%eax),%ecx
  80048c:	8b 45 10             	mov    0x10(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	89 cb                	mov    %ecx,%ebx
  800493:	29 c3                	sub    %eax,%ebx
  800495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800498:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 08                	mov    (%eax),%ecx
  8004a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	29 c1                	sub    %eax,%ecx
  8004ad:	89 c8                	mov    %ecx,%eax
  8004af:	0f af c3             	imul   %ebx,%eax
  8004b2:	01 c2                	add    %eax,%edx
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	89 10                	mov    %edx,(%eax)

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b9:	ff 45 f4             	incl   -0xc(%ebp)
  8004bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004c2:	7c b2                	jl     800476 <ArrayStats+0x101>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
	}
	(*var) /= NumOfElements;
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
  8004ca:	f7 7d 0c             	idivl  0xc(%ebp)
  8004cd:	89 c2                	mov    %eax,%edx
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
}
  8004d4:	90                   	nop
  8004d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	01 c2                	add    %eax,%edx
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	01 c8                	add    %ecx,%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800516:	8b 45 10             	mov    0x10(%ebp),%eax
  800519:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	01 c2                	add    %eax,%edx
  800525:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800528:	89 02                	mov    %eax,(%edx)
}
  80052a:	90                   	nop
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800533:	e8 a2 15 00 00       	call   801ada <sys_getenvindex>
  800538:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80053b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	c1 e0 03             	shl    $0x3,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80054c:	01 c8                	add    %ecx,%eax
  80054e:	01 c0                	add    %eax,%eax
  800550:	01 d0                	add    %edx,%eax
  800552:	01 c0                	add    %eax,%eax
  800554:	01 d0                	add    %edx,%eax
  800556:	89 c2                	mov    %eax,%edx
  800558:	c1 e2 05             	shl    $0x5,%edx
  80055b:	29 c2                	sub    %eax,%edx
  80055d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800564:	89 c2                	mov    %eax,%edx
  800566:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80056c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800571:	a1 20 30 80 00       	mov    0x803020,%eax
  800576:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80057c:	84 c0                	test   %al,%al
  80057e:	74 0f                	je     80058f <libmain+0x62>
		binaryname = myEnv->prog_name;
  800580:	a1 20 30 80 00       	mov    0x803020,%eax
  800585:	05 40 3c 01 00       	add    $0x13c40,%eax
  80058a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80058f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800593:	7e 0a                	jle    80059f <libmain+0x72>
		binaryname = argv[0];
  800595:	8b 45 0c             	mov    0xc(%ebp),%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80059f:	83 ec 08             	sub    $0x8,%esp
  8005a2:	ff 75 0c             	pushl  0xc(%ebp)
  8005a5:	ff 75 08             	pushl  0x8(%ebp)
  8005a8:	e8 8b fa ff ff       	call   800038 <_main>
  8005ad:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8005b0:	e8 c0 16 00 00       	call   801c75 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005b5:	83 ec 0c             	sub    $0xc,%esp
  8005b8:	68 58 25 80 00       	push   $0x802558
  8005bd:	e8 84 01 00 00       	call   800746 <cprintf>
  8005c2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ca:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8005d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8005d5:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8005db:	83 ec 04             	sub    $0x4,%esp
  8005de:	52                   	push   %edx
  8005df:	50                   	push   %eax
  8005e0:	68 80 25 80 00       	push   $0x802580
  8005e5:	e8 5c 01 00 00       	call   800746 <cprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8005ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f2:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8005f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fd:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800603:	83 ec 04             	sub    $0x4,%esp
  800606:	52                   	push   %edx
  800607:	50                   	push   %eax
  800608:	68 a8 25 80 00       	push   $0x8025a8
  80060d:	e8 34 01 00 00       	call   800746 <cprintf>
  800612:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800615:	a1 20 30 80 00       	mov    0x803020,%eax
  80061a:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	50                   	push   %eax
  800624:	68 e9 25 80 00       	push   $0x8025e9
  800629:	e8 18 01 00 00       	call   800746 <cprintf>
  80062e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800631:	83 ec 0c             	sub    $0xc,%esp
  800634:	68 58 25 80 00       	push   $0x802558
  800639:	e8 08 01 00 00       	call   800746 <cprintf>
  80063e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800641:	e8 49 16 00 00       	call   801c8f <sys_enable_interrupt>

	// exit gracefully
	exit();
  800646:	e8 19 00 00 00       	call   800664 <exit>
}
  80064b:	90                   	nop
  80064c:	c9                   	leave  
  80064d:	c3                   	ret    

0080064e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80064e:	55                   	push   %ebp
  80064f:	89 e5                	mov    %esp,%ebp
  800651:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800654:	83 ec 0c             	sub    $0xc,%esp
  800657:	6a 00                	push   $0x0
  800659:	e8 48 14 00 00       	call   801aa6 <sys_env_destroy>
  80065e:	83 c4 10             	add    $0x10,%esp
}
  800661:	90                   	nop
  800662:	c9                   	leave  
  800663:	c3                   	ret    

00800664 <exit>:

void
exit(void)
{
  800664:	55                   	push   %ebp
  800665:	89 e5                	mov    %esp,%ebp
  800667:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80066a:	e8 9d 14 00 00       	call   801b0c <sys_env_exit>
}
  80066f:	90                   	nop
  800670:	c9                   	leave  
  800671:	c3                   	ret    

00800672 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800672:	55                   	push   %ebp
  800673:	89 e5                	mov    %esp,%ebp
  800675:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800678:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067b:	8b 00                	mov    (%eax),%eax
  80067d:	8d 48 01             	lea    0x1(%eax),%ecx
  800680:	8b 55 0c             	mov    0xc(%ebp),%edx
  800683:	89 0a                	mov    %ecx,(%edx)
  800685:	8b 55 08             	mov    0x8(%ebp),%edx
  800688:	88 d1                	mov    %dl,%cl
  80068a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800691:	8b 45 0c             	mov    0xc(%ebp),%eax
  800694:	8b 00                	mov    (%eax),%eax
  800696:	3d ff 00 00 00       	cmp    $0xff,%eax
  80069b:	75 2c                	jne    8006c9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80069d:	a0 24 30 80 00       	mov    0x803024,%al
  8006a2:	0f b6 c0             	movzbl %al,%eax
  8006a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a8:	8b 12                	mov    (%edx),%edx
  8006aa:	89 d1                	mov    %edx,%ecx
  8006ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006af:	83 c2 08             	add    $0x8,%edx
  8006b2:	83 ec 04             	sub    $0x4,%esp
  8006b5:	50                   	push   %eax
  8006b6:	51                   	push   %ecx
  8006b7:	52                   	push   %edx
  8006b8:	e8 a7 13 00 00       	call   801a64 <sys_cputs>
  8006bd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cc:	8b 40 04             	mov    0x4(%eax),%eax
  8006cf:	8d 50 01             	lea    0x1(%eax),%edx
  8006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006d8:	90                   	nop
  8006d9:	c9                   	leave  
  8006da:	c3                   	ret    

008006db <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006db:	55                   	push   %ebp
  8006dc:	89 e5                	mov    %esp,%ebp
  8006de:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006e4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006eb:	00 00 00 
	b.cnt = 0;
  8006ee:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006f5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006f8:	ff 75 0c             	pushl  0xc(%ebp)
  8006fb:	ff 75 08             	pushl  0x8(%ebp)
  8006fe:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800704:	50                   	push   %eax
  800705:	68 72 06 80 00       	push   $0x800672
  80070a:	e8 11 02 00 00       	call   800920 <vprintfmt>
  80070f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800712:	a0 24 30 80 00       	mov    0x803024,%al
  800717:	0f b6 c0             	movzbl %al,%eax
  80071a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800720:	83 ec 04             	sub    $0x4,%esp
  800723:	50                   	push   %eax
  800724:	52                   	push   %edx
  800725:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072b:	83 c0 08             	add    $0x8,%eax
  80072e:	50                   	push   %eax
  80072f:	e8 30 13 00 00       	call   801a64 <sys_cputs>
  800734:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800737:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80073e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800744:	c9                   	leave  
  800745:	c3                   	ret    

00800746 <cprintf>:

int cprintf(const char *fmt, ...) {
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80074c:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800753:	8d 45 0c             	lea    0xc(%ebp),%eax
  800756:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 f4             	pushl  -0xc(%ebp)
  800762:	50                   	push   %eax
  800763:	e8 73 ff ff ff       	call   8006db <vcprintf>
  800768:	83 c4 10             	add    $0x10,%esp
  80076b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80076e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800771:	c9                   	leave  
  800772:	c3                   	ret    

00800773 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800773:	55                   	push   %ebp
  800774:	89 e5                	mov    %esp,%ebp
  800776:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800779:	e8 f7 14 00 00       	call   801c75 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80077e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 f4             	pushl  -0xc(%ebp)
  80078d:	50                   	push   %eax
  80078e:	e8 48 ff ff ff       	call   8006db <vcprintf>
  800793:	83 c4 10             	add    $0x10,%esp
  800796:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800799:	e8 f1 14 00 00       	call   801c8f <sys_enable_interrupt>
	return cnt;
  80079e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a1:	c9                   	leave  
  8007a2:	c3                   	ret    

008007a3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	53                   	push   %ebx
  8007a7:	83 ec 14             	sub    $0x14,%esp
  8007aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007b6:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007be:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c1:	77 55                	ja     800818 <printnum+0x75>
  8007c3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c6:	72 05                	jb     8007cd <printnum+0x2a>
  8007c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007cb:	77 4b                	ja     800818 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007cd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007d0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007d3:	8b 45 18             	mov    0x18(%ebp),%eax
  8007d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007db:	52                   	push   %edx
  8007dc:	50                   	push   %eax
  8007dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e0:	ff 75 f0             	pushl  -0x10(%ebp)
  8007e3:	e8 7c 1a 00 00       	call   802264 <__udivdi3>
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	83 ec 04             	sub    $0x4,%esp
  8007ee:	ff 75 20             	pushl  0x20(%ebp)
  8007f1:	53                   	push   %ebx
  8007f2:	ff 75 18             	pushl  0x18(%ebp)
  8007f5:	52                   	push   %edx
  8007f6:	50                   	push   %eax
  8007f7:	ff 75 0c             	pushl  0xc(%ebp)
  8007fa:	ff 75 08             	pushl  0x8(%ebp)
  8007fd:	e8 a1 ff ff ff       	call   8007a3 <printnum>
  800802:	83 c4 20             	add    $0x20,%esp
  800805:	eb 1a                	jmp    800821 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	ff 75 0c             	pushl  0xc(%ebp)
  80080d:	ff 75 20             	pushl  0x20(%ebp)
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	ff d0                	call   *%eax
  800815:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800818:	ff 4d 1c             	decl   0x1c(%ebp)
  80081b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80081f:	7f e6                	jg     800807 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800821:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800824:	bb 00 00 00 00       	mov    $0x0,%ebx
  800829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80082f:	53                   	push   %ebx
  800830:	51                   	push   %ecx
  800831:	52                   	push   %edx
  800832:	50                   	push   %eax
  800833:	e8 3c 1b 00 00       	call   802374 <__umoddi3>
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	05 14 28 80 00       	add    $0x802814,%eax
  800840:	8a 00                	mov    (%eax),%al
  800842:	0f be c0             	movsbl %al,%eax
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	50                   	push   %eax
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	ff d0                	call   *%eax
  800851:	83 c4 10             	add    $0x10,%esp
}
  800854:	90                   	nop
  800855:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800858:	c9                   	leave  
  800859:	c3                   	ret    

0080085a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80085d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800861:	7e 1c                	jle    80087f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	8d 50 08             	lea    0x8(%eax),%edx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	89 10                	mov    %edx,(%eax)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	83 e8 08             	sub    $0x8,%eax
  800878:	8b 50 04             	mov    0x4(%eax),%edx
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	eb 40                	jmp    8008bf <getuint+0x65>
	else if (lflag)
  80087f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800883:	74 1e                	je     8008a3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	8d 50 04             	lea    0x4(%eax),%edx
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	89 10                	mov    %edx,(%eax)
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	8b 00                	mov    (%eax),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 00                	mov    (%eax),%eax
  80089c:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a1:	eb 1c                	jmp    8008bf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	8b 00                	mov    (%eax),%eax
  8008a8:	8d 50 04             	lea    0x4(%eax),%edx
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	89 10                	mov    %edx,(%eax)
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	8b 00                	mov    (%eax),%eax
  8008b5:	83 e8 04             	sub    $0x4,%eax
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008bf:	5d                   	pop    %ebp
  8008c0:	c3                   	ret    

008008c1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c8:	7e 1c                	jle    8008e6 <getint+0x25>
		return va_arg(*ap, long long);
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	8d 50 08             	lea    0x8(%eax),%edx
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	89 10                	mov    %edx,(%eax)
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	83 e8 08             	sub    $0x8,%eax
  8008df:	8b 50 04             	mov    0x4(%eax),%edx
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	eb 38                	jmp    80091e <getint+0x5d>
	else if (lflag)
  8008e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ea:	74 1a                	je     800906 <getint+0x45>
		return va_arg(*ap, long);
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	8d 50 04             	lea    0x4(%eax),%edx
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	89 10                	mov    %edx,(%eax)
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	83 e8 04             	sub    $0x4,%eax
  800901:	8b 00                	mov    (%eax),%eax
  800903:	99                   	cltd   
  800904:	eb 18                	jmp    80091e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	8d 50 04             	lea    0x4(%eax),%edx
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	89 10                	mov    %edx,(%eax)
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	83 e8 04             	sub    $0x4,%eax
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	99                   	cltd   
}
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	56                   	push   %esi
  800924:	53                   	push   %ebx
  800925:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800928:	eb 17                	jmp    800941 <vprintfmt+0x21>
			if (ch == '\0')
  80092a:	85 db                	test   %ebx,%ebx
  80092c:	0f 84 af 03 00 00    	je     800ce1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	53                   	push   %ebx
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	ff d0                	call   *%eax
  80093e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800941:	8b 45 10             	mov    0x10(%ebp),%eax
  800944:	8d 50 01             	lea    0x1(%eax),%edx
  800947:	89 55 10             	mov    %edx,0x10(%ebp)
  80094a:	8a 00                	mov    (%eax),%al
  80094c:	0f b6 d8             	movzbl %al,%ebx
  80094f:	83 fb 25             	cmp    $0x25,%ebx
  800952:	75 d6                	jne    80092a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800954:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800958:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80095f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800966:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80096d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800974:	8b 45 10             	mov    0x10(%ebp),%eax
  800977:	8d 50 01             	lea    0x1(%eax),%edx
  80097a:	89 55 10             	mov    %edx,0x10(%ebp)
  80097d:	8a 00                	mov    (%eax),%al
  80097f:	0f b6 d8             	movzbl %al,%ebx
  800982:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800985:	83 f8 55             	cmp    $0x55,%eax
  800988:	0f 87 2b 03 00 00    	ja     800cb9 <vprintfmt+0x399>
  80098e:	8b 04 85 38 28 80 00 	mov    0x802838(,%eax,4),%eax
  800995:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800997:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80099b:	eb d7                	jmp    800974 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80099d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009a1:	eb d1                	jmp    800974 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009ad:	89 d0                	mov    %edx,%eax
  8009af:	c1 e0 02             	shl    $0x2,%eax
  8009b2:	01 d0                	add    %edx,%eax
  8009b4:	01 c0                	add    %eax,%eax
  8009b6:	01 d8                	add    %ebx,%eax
  8009b8:	83 e8 30             	sub    $0x30,%eax
  8009bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009be:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009c6:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c9:	7e 3e                	jle    800a09 <vprintfmt+0xe9>
  8009cb:	83 fb 39             	cmp    $0x39,%ebx
  8009ce:	7f 39                	jg     800a09 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009d3:	eb d5                	jmp    8009aa <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 c0 04             	add    $0x4,%eax
  8009db:	89 45 14             	mov    %eax,0x14(%ebp)
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	83 e8 04             	sub    $0x4,%eax
  8009e4:	8b 00                	mov    (%eax),%eax
  8009e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e9:	eb 1f                	jmp    800a0a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ef:	79 83                	jns    800974 <vprintfmt+0x54>
				width = 0;
  8009f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009f8:	e9 77 ff ff ff       	jmp    800974 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009fd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a04:	e9 6b ff ff ff       	jmp    800974 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a09:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a0e:	0f 89 60 ff ff ff    	jns    800974 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a1a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a21:	e9 4e ff ff ff       	jmp    800974 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a26:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a29:	e9 46 ff ff ff       	jmp    800974 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 c0 04             	add    $0x4,%eax
  800a34:	89 45 14             	mov    %eax,0x14(%ebp)
  800a37:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3a:	83 e8 04             	sub    $0x4,%eax
  800a3d:	8b 00                	mov    (%eax),%eax
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	ff 75 0c             	pushl  0xc(%ebp)
  800a45:	50                   	push   %eax
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	ff d0                	call   *%eax
  800a4b:	83 c4 10             	add    $0x10,%esp
			break;
  800a4e:	e9 89 02 00 00       	jmp    800cdc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	83 c0 04             	add    $0x4,%eax
  800a59:	89 45 14             	mov    %eax,0x14(%ebp)
  800a5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5f:	83 e8 04             	sub    $0x4,%eax
  800a62:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a64:	85 db                	test   %ebx,%ebx
  800a66:	79 02                	jns    800a6a <vprintfmt+0x14a>
				err = -err;
  800a68:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a6a:	83 fb 64             	cmp    $0x64,%ebx
  800a6d:	7f 0b                	jg     800a7a <vprintfmt+0x15a>
  800a6f:	8b 34 9d 80 26 80 00 	mov    0x802680(,%ebx,4),%esi
  800a76:	85 f6                	test   %esi,%esi
  800a78:	75 19                	jne    800a93 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a7a:	53                   	push   %ebx
  800a7b:	68 25 28 80 00       	push   $0x802825
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	ff 75 08             	pushl  0x8(%ebp)
  800a86:	e8 5e 02 00 00       	call   800ce9 <printfmt>
  800a8b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a8e:	e9 49 02 00 00       	jmp    800cdc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a93:	56                   	push   %esi
  800a94:	68 2e 28 80 00       	push   $0x80282e
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	ff 75 08             	pushl  0x8(%ebp)
  800a9f:	e8 45 02 00 00       	call   800ce9 <printfmt>
  800aa4:	83 c4 10             	add    $0x10,%esp
			break;
  800aa7:	e9 30 02 00 00       	jmp    800cdc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	83 c0 04             	add    $0x4,%eax
  800ab2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab8:	83 e8 04             	sub    $0x4,%eax
  800abb:	8b 30                	mov    (%eax),%esi
  800abd:	85 f6                	test   %esi,%esi
  800abf:	75 05                	jne    800ac6 <vprintfmt+0x1a6>
				p = "(null)";
  800ac1:	be 31 28 80 00       	mov    $0x802831,%esi
			if (width > 0 && padc != '-')
  800ac6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aca:	7e 6d                	jle    800b39 <vprintfmt+0x219>
  800acc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ad0:	74 67                	je     800b39 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	50                   	push   %eax
  800ad9:	56                   	push   %esi
  800ada:	e8 0c 03 00 00       	call   800deb <strnlen>
  800adf:	83 c4 10             	add    $0x10,%esp
  800ae2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ae5:	eb 16                	jmp    800afd <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ae7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	50                   	push   %eax
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	ff d0                	call   *%eax
  800af7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800afa:	ff 4d e4             	decl   -0x1c(%ebp)
  800afd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b01:	7f e4                	jg     800ae7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b03:	eb 34                	jmp    800b39 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b05:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b09:	74 1c                	je     800b27 <vprintfmt+0x207>
  800b0b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b0e:	7e 05                	jle    800b15 <vprintfmt+0x1f5>
  800b10:	83 fb 7e             	cmp    $0x7e,%ebx
  800b13:	7e 12                	jle    800b27 <vprintfmt+0x207>
					putch('?', putdat);
  800b15:	83 ec 08             	sub    $0x8,%esp
  800b18:	ff 75 0c             	pushl  0xc(%ebp)
  800b1b:	6a 3f                	push   $0x3f
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	ff d0                	call   *%eax
  800b22:	83 c4 10             	add    $0x10,%esp
  800b25:	eb 0f                	jmp    800b36 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	53                   	push   %ebx
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	ff d0                	call   *%eax
  800b33:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b36:	ff 4d e4             	decl   -0x1c(%ebp)
  800b39:	89 f0                	mov    %esi,%eax
  800b3b:	8d 70 01             	lea    0x1(%eax),%esi
  800b3e:	8a 00                	mov    (%eax),%al
  800b40:	0f be d8             	movsbl %al,%ebx
  800b43:	85 db                	test   %ebx,%ebx
  800b45:	74 24                	je     800b6b <vprintfmt+0x24b>
  800b47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4b:	78 b8                	js     800b05 <vprintfmt+0x1e5>
  800b4d:	ff 4d e0             	decl   -0x20(%ebp)
  800b50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b54:	79 af                	jns    800b05 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b56:	eb 13                	jmp    800b6b <vprintfmt+0x24b>
				putch(' ', putdat);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	ff 75 0c             	pushl  0xc(%ebp)
  800b5e:	6a 20                	push   $0x20
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	ff d0                	call   *%eax
  800b65:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b68:	ff 4d e4             	decl   -0x1c(%ebp)
  800b6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6f:	7f e7                	jg     800b58 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b71:	e9 66 01 00 00       	jmp    800cdc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b76:	83 ec 08             	sub    $0x8,%esp
  800b79:	ff 75 e8             	pushl  -0x18(%ebp)
  800b7c:	8d 45 14             	lea    0x14(%ebp),%eax
  800b7f:	50                   	push   %eax
  800b80:	e8 3c fd ff ff       	call   8008c1 <getint>
  800b85:	83 c4 10             	add    $0x10,%esp
  800b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b94:	85 d2                	test   %edx,%edx
  800b96:	79 23                	jns    800bbb <vprintfmt+0x29b>
				putch('-', putdat);
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	ff 75 0c             	pushl  0xc(%ebp)
  800b9e:	6a 2d                	push   $0x2d
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	ff d0                	call   *%eax
  800ba5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bae:	f7 d8                	neg    %eax
  800bb0:	83 d2 00             	adc    $0x0,%edx
  800bb3:	f7 da                	neg    %edx
  800bb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bbb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bc2:	e9 bc 00 00 00       	jmp    800c83 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 e8             	pushl  -0x18(%ebp)
  800bcd:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd0:	50                   	push   %eax
  800bd1:	e8 84 fc ff ff       	call   80085a <getuint>
  800bd6:	83 c4 10             	add    $0x10,%esp
  800bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bdf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800be6:	e9 98 00 00 00       	jmp    800c83 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800beb:	83 ec 08             	sub    $0x8,%esp
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	6a 58                	push   $0x58
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	ff d0                	call   *%eax
  800bf8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bfb:	83 ec 08             	sub    $0x8,%esp
  800bfe:	ff 75 0c             	pushl  0xc(%ebp)
  800c01:	6a 58                	push   $0x58
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	ff d0                	call   *%eax
  800c08:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 0c             	pushl  0xc(%ebp)
  800c11:	6a 58                	push   $0x58
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	ff d0                	call   *%eax
  800c18:	83 c4 10             	add    $0x10,%esp
			break;
  800c1b:	e9 bc 00 00 00       	jmp    800cdc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	6a 30                	push   $0x30
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	ff d0                	call   *%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c30:	83 ec 08             	sub    $0x8,%esp
  800c33:	ff 75 0c             	pushl  0xc(%ebp)
  800c36:	6a 78                	push   $0x78
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	ff d0                	call   *%eax
  800c3d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c40:	8b 45 14             	mov    0x14(%ebp),%eax
  800c43:	83 c0 04             	add    $0x4,%eax
  800c46:	89 45 14             	mov    %eax,0x14(%ebp)
  800c49:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4c:	83 e8 04             	sub    $0x4,%eax
  800c4f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c5b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c62:	eb 1f                	jmp    800c83 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 e8             	pushl  -0x18(%ebp)
  800c6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c6d:	50                   	push   %eax
  800c6e:	e8 e7 fb ff ff       	call   80085a <getuint>
  800c73:	83 c4 10             	add    $0x10,%esp
  800c76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c7c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c83:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c8a:	83 ec 04             	sub    $0x4,%esp
  800c8d:	52                   	push   %edx
  800c8e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c91:	50                   	push   %eax
  800c92:	ff 75 f4             	pushl  -0xc(%ebp)
  800c95:	ff 75 f0             	pushl  -0x10(%ebp)
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	ff 75 08             	pushl  0x8(%ebp)
  800c9e:	e8 00 fb ff ff       	call   8007a3 <printnum>
  800ca3:	83 c4 20             	add    $0x20,%esp
			break;
  800ca6:	eb 34                	jmp    800cdc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 0c             	pushl  0xc(%ebp)
  800cae:	53                   	push   %ebx
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	ff d0                	call   *%eax
  800cb4:	83 c4 10             	add    $0x10,%esp
			break;
  800cb7:	eb 23                	jmp    800cdc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cb9:	83 ec 08             	sub    $0x8,%esp
  800cbc:	ff 75 0c             	pushl  0xc(%ebp)
  800cbf:	6a 25                	push   $0x25
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	ff d0                	call   *%eax
  800cc6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc9:	ff 4d 10             	decl   0x10(%ebp)
  800ccc:	eb 03                	jmp    800cd1 <vprintfmt+0x3b1>
  800cce:	ff 4d 10             	decl   0x10(%ebp)
  800cd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd4:	48                   	dec    %eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	3c 25                	cmp    $0x25,%al
  800cd9:	75 f3                	jne    800cce <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cdb:	90                   	nop
		}
	}
  800cdc:	e9 47 fc ff ff       	jmp    800928 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ce1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ce2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    

00800ce9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cef:	8d 45 10             	lea    0x10(%ebp),%eax
  800cf2:	83 c0 04             	add    $0x4,%eax
  800cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfe:	50                   	push   %eax
  800cff:	ff 75 0c             	pushl  0xc(%ebp)
  800d02:	ff 75 08             	pushl  0x8(%ebp)
  800d05:	e8 16 fc ff ff       	call   800920 <vprintfmt>
  800d0a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d0d:	90                   	nop
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	8b 40 08             	mov    0x8(%eax),%eax
  800d19:	8d 50 01             	lea    0x1(%eax),%edx
  800d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8b 10                	mov    (%eax),%edx
  800d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2a:	8b 40 04             	mov    0x4(%eax),%eax
  800d2d:	39 c2                	cmp    %eax,%edx
  800d2f:	73 12                	jae    800d43 <sprintputch+0x33>
		*b->buf++ = ch;
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8b 00                	mov    (%eax),%eax
  800d36:	8d 48 01             	lea    0x1(%eax),%ecx
  800d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3c:	89 0a                	mov    %ecx,(%edx)
  800d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d41:	88 10                	mov    %dl,(%eax)
}
  800d43:	90                   	nop
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	01 d0                	add    %edx,%eax
  800d5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d6b:	74 06                	je     800d73 <vsnprintf+0x2d>
  800d6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d71:	7f 07                	jg     800d7a <vsnprintf+0x34>
		return -E_INVAL;
  800d73:	b8 03 00 00 00       	mov    $0x3,%eax
  800d78:	eb 20                	jmp    800d9a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d7a:	ff 75 14             	pushl  0x14(%ebp)
  800d7d:	ff 75 10             	pushl  0x10(%ebp)
  800d80:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d83:	50                   	push   %eax
  800d84:	68 10 0d 80 00       	push   $0x800d10
  800d89:	e8 92 fb ff ff       	call   800920 <vprintfmt>
  800d8e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d94:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d9a:	c9                   	leave  
  800d9b:	c3                   	ret    

00800d9c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800da2:	8d 45 10             	lea    0x10(%ebp),%eax
  800da5:	83 c0 04             	add    $0x4,%eax
  800da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dab:	8b 45 10             	mov    0x10(%ebp),%eax
  800dae:	ff 75 f4             	pushl  -0xc(%ebp)
  800db1:	50                   	push   %eax
  800db2:	ff 75 0c             	pushl  0xc(%ebp)
  800db5:	ff 75 08             	pushl  0x8(%ebp)
  800db8:	e8 89 ff ff ff       	call   800d46 <vsnprintf>
  800dbd:	83 c4 10             	add    $0x10,%esp
  800dc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd5:	eb 06                	jmp    800ddd <strlen+0x15>
		n++;
  800dd7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dda:	ff 45 08             	incl   0x8(%ebp)
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	84 c0                	test   %al,%al
  800de4:	75 f1                	jne    800dd7 <strlen+0xf>
		n++;
	return n;
  800de6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800df8:	eb 09                	jmp    800e03 <strnlen+0x18>
		n++;
  800dfa:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dfd:	ff 45 08             	incl   0x8(%ebp)
  800e00:	ff 4d 0c             	decl   0xc(%ebp)
  800e03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e07:	74 09                	je     800e12 <strnlen+0x27>
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	84 c0                	test   %al,%al
  800e10:	75 e8                	jne    800dfa <strnlen+0xf>
		n++;
	return n;
  800e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e23:	90                   	nop
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8d 50 01             	lea    0x1(%eax),%edx
  800e2a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e30:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e33:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e36:	8a 12                	mov    (%edx),%dl
  800e38:	88 10                	mov    %dl,(%eax)
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	84 c0                	test   %al,%al
  800e3e:	75 e4                	jne    800e24 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e40:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e58:	eb 1f                	jmp    800e79 <strncpy+0x34>
		*dst++ = *src;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	8d 50 01             	lea    0x1(%eax),%edx
  800e60:	89 55 08             	mov    %edx,0x8(%ebp)
  800e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e66:	8a 12                	mov    (%edx),%dl
  800e68:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	84 c0                	test   %al,%al
  800e71:	74 03                	je     800e76 <strncpy+0x31>
			src++;
  800e73:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e76:	ff 45 fc             	incl   -0x4(%ebp)
  800e79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e7f:	72 d9                	jb     800e5a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    

00800e86 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e96:	74 30                	je     800ec8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e98:	eb 16                	jmp    800eb0 <strlcpy+0x2a>
			*dst++ = *src++;
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eac:	8a 12                	mov    (%edx),%dl
  800eae:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eb0:	ff 4d 10             	decl   0x10(%ebp)
  800eb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb7:	74 09                	je     800ec2 <strlcpy+0x3c>
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	84 c0                	test   %al,%al
  800ec0:	75 d8                	jne    800e9a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ece:	29 c2                	sub    %eax,%edx
  800ed0:	89 d0                	mov    %edx,%eax
}
  800ed2:	c9                   	leave  
  800ed3:	c3                   	ret    

00800ed4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ed7:	eb 06                	jmp    800edf <strcmp+0xb>
		p++, q++;
  800ed9:	ff 45 08             	incl   0x8(%ebp)
  800edc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 00                	mov    (%eax),%al
  800ee4:	84 c0                	test   %al,%al
  800ee6:	74 0e                	je     800ef6 <strcmp+0x22>
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 10                	mov    (%eax),%dl
  800eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	38 c2                	cmp    %al,%dl
  800ef4:	74 e3                	je     800ed9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	0f b6 d0             	movzbl %al,%edx
  800efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	0f b6 c0             	movzbl %al,%eax
  800f06:	29 c2                	sub    %eax,%edx
  800f08:	89 d0                	mov    %edx,%eax
}
  800f0a:	5d                   	pop    %ebp
  800f0b:	c3                   	ret    

00800f0c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f0f:	eb 09                	jmp    800f1a <strncmp+0xe>
		n--, p++, q++;
  800f11:	ff 4d 10             	decl   0x10(%ebp)
  800f14:	ff 45 08             	incl   0x8(%ebp)
  800f17:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1e:	74 17                	je     800f37 <strncmp+0x2b>
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	84 c0                	test   %al,%al
  800f27:	74 0e                	je     800f37 <strncmp+0x2b>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 10                	mov    (%eax),%dl
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	38 c2                	cmp    %al,%dl
  800f35:	74 da                	je     800f11 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3b:	75 07                	jne    800f44 <strncmp+0x38>
		return 0;
  800f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f42:	eb 14                	jmp    800f58 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	0f b6 d0             	movzbl %al,%edx
  800f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	0f b6 c0             	movzbl %al,%eax
  800f54:	29 c2                	sub    %eax,%edx
  800f56:	89 d0                	mov    %edx,%eax
}
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    

00800f5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 04             	sub    $0x4,%esp
  800f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f63:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f66:	eb 12                	jmp    800f7a <strchr+0x20>
		if (*s == c)
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f70:	75 05                	jne    800f77 <strchr+0x1d>
			return (char *) s;
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	eb 11                	jmp    800f88 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f77:	ff 45 08             	incl   0x8(%ebp)
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	84 c0                	test   %al,%al
  800f81:	75 e5                	jne    800f68 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	83 ec 04             	sub    $0x4,%esp
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f96:	eb 0d                	jmp    800fa5 <strfind+0x1b>
		if (*s == c)
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa0:	74 0e                	je     800fb0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fa2:	ff 45 08             	incl   0x8(%ebp)
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	84 c0                	test   %al,%al
  800fac:	75 ea                	jne    800f98 <strfind+0xe>
  800fae:	eb 01                	jmp    800fb1 <strfind+0x27>
		if (*s == c)
			break;
  800fb0:	90                   	nop
	return (char *) s;
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb4:	c9                   	leave  
  800fb5:	c3                   	ret    

00800fb6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fc8:	eb 0e                	jmp    800fd8 <memset+0x22>
		*p++ = c;
  800fca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcd:	8d 50 01             	lea    0x1(%eax),%edx
  800fd0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fd8:	ff 4d f8             	decl   -0x8(%ebp)
  800fdb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fdf:	79 e9                	jns    800fca <memset+0x14>
		*p++ = c;

	return v;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe4:	c9                   	leave  
  800fe5:	c3                   	ret    

00800fe6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ff8:	eb 16                	jmp    801010 <memcpy+0x2a>
		*d++ = *s++;
  800ffa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffd:	8d 50 01             	lea    0x1(%eax),%edx
  801000:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801003:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801006:	8d 4a 01             	lea    0x1(%edx),%ecx
  801009:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80100c:	8a 12                	mov    (%edx),%dl
  80100e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801010:	8b 45 10             	mov    0x10(%ebp),%eax
  801013:	8d 50 ff             	lea    -0x1(%eax),%edx
  801016:	89 55 10             	mov    %edx,0x10(%ebp)
  801019:	85 c0                	test   %eax,%eax
  80101b:	75 dd                	jne    800ffa <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801020:	c9                   	leave  
  801021:	c3                   	ret    

00801022 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801034:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801037:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80103a:	73 50                	jae    80108c <memmove+0x6a>
  80103c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	01 d0                	add    %edx,%eax
  801044:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801047:	76 43                	jbe    80108c <memmove+0x6a>
		s += n;
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80104f:	8b 45 10             	mov    0x10(%ebp),%eax
  801052:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801055:	eb 10                	jmp    801067 <memmove+0x45>
			*--d = *--s;
  801057:	ff 4d f8             	decl   -0x8(%ebp)
  80105a:	ff 4d fc             	decl   -0x4(%ebp)
  80105d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801060:	8a 10                	mov    (%eax),%dl
  801062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801065:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801067:	8b 45 10             	mov    0x10(%ebp),%eax
  80106a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80106d:	89 55 10             	mov    %edx,0x10(%ebp)
  801070:	85 c0                	test   %eax,%eax
  801072:	75 e3                	jne    801057 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801074:	eb 23                	jmp    801099 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801076:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801079:	8d 50 01             	lea    0x1(%eax),%edx
  80107c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801082:	8d 4a 01             	lea    0x1(%edx),%ecx
  801085:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801088:	8a 12                	mov    (%edx),%dl
  80108a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80108c:	8b 45 10             	mov    0x10(%ebp),%eax
  80108f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801092:	89 55 10             	mov    %edx,0x10(%ebp)
  801095:	85 c0                	test   %eax,%eax
  801097:	75 dd                	jne    801076 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    

0080109e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ad:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010b0:	eb 2a                	jmp    8010dc <memcmp+0x3e>
		if (*s1 != *s2)
  8010b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b5:	8a 10                	mov    (%eax),%dl
  8010b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	38 c2                	cmp    %al,%dl
  8010be:	74 16                	je     8010d6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	0f b6 d0             	movzbl %al,%edx
  8010c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	0f b6 c0             	movzbl %al,%eax
  8010d0:	29 c2                	sub    %eax,%edx
  8010d2:	89 d0                	mov    %edx,%eax
  8010d4:	eb 18                	jmp    8010ee <memcmp+0x50>
		s1++, s2++;
  8010d6:	ff 45 fc             	incl   -0x4(%ebp)
  8010d9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	75 c9                	jne    8010b2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fc:	01 d0                	add    %edx,%eax
  8010fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801101:	eb 15                	jmp    801118 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	8a 00                	mov    (%eax),%al
  801108:	0f b6 d0             	movzbl %al,%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	0f b6 c0             	movzbl %al,%eax
  801111:	39 c2                	cmp    %eax,%edx
  801113:	74 0d                	je     801122 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801115:	ff 45 08             	incl   0x8(%ebp)
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80111e:	72 e3                	jb     801103 <memfind+0x13>
  801120:	eb 01                	jmp    801123 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801122:	90                   	nop
	return (void *) s;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801126:	c9                   	leave  
  801127:	c3                   	ret    

00801128 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80112e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801135:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80113c:	eb 03                	jmp    801141 <strtol+0x19>
		s++;
  80113e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 20                	cmp    $0x20,%al
  801148:	74 f4                	je     80113e <strtol+0x16>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 09                	cmp    $0x9,%al
  801151:	74 eb                	je     80113e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	3c 2b                	cmp    $0x2b,%al
  80115a:	75 05                	jne    801161 <strtol+0x39>
		s++;
  80115c:	ff 45 08             	incl   0x8(%ebp)
  80115f:	eb 13                	jmp    801174 <strtol+0x4c>
	else if (*s == '-')
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	3c 2d                	cmp    $0x2d,%al
  801168:	75 0a                	jne    801174 <strtol+0x4c>
		s++, neg = 1;
  80116a:	ff 45 08             	incl   0x8(%ebp)
  80116d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801174:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801178:	74 06                	je     801180 <strtol+0x58>
  80117a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80117e:	75 20                	jne    8011a0 <strtol+0x78>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	3c 30                	cmp    $0x30,%al
  801187:	75 17                	jne    8011a0 <strtol+0x78>
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	40                   	inc    %eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 78                	cmp    $0x78,%al
  801191:	75 0d                	jne    8011a0 <strtol+0x78>
		s += 2, base = 16;
  801193:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801197:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80119e:	eb 28                	jmp    8011c8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a4:	75 15                	jne    8011bb <strtol+0x93>
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	3c 30                	cmp    $0x30,%al
  8011ad:	75 0c                	jne    8011bb <strtol+0x93>
		s++, base = 8;
  8011af:	ff 45 08             	incl   0x8(%ebp)
  8011b2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011b9:	eb 0d                	jmp    8011c8 <strtol+0xa0>
	else if (base == 0)
  8011bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bf:	75 07                	jne    8011c8 <strtol+0xa0>
		base = 10;
  8011c1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	3c 2f                	cmp    $0x2f,%al
  8011cf:	7e 19                	jle    8011ea <strtol+0xc2>
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	3c 39                	cmp    $0x39,%al
  8011d8:	7f 10                	jg     8011ea <strtol+0xc2>
			dig = *s - '0';
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	0f be c0             	movsbl %al,%eax
  8011e2:	83 e8 30             	sub    $0x30,%eax
  8011e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011e8:	eb 42                	jmp    80122c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 60                	cmp    $0x60,%al
  8011f1:	7e 19                	jle    80120c <strtol+0xe4>
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	3c 7a                	cmp    $0x7a,%al
  8011fa:	7f 10                	jg     80120c <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	0f be c0             	movsbl %al,%eax
  801204:	83 e8 57             	sub    $0x57,%eax
  801207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80120a:	eb 20                	jmp    80122c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 40                	cmp    $0x40,%al
  801213:	7e 39                	jle    80124e <strtol+0x126>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	3c 5a                	cmp    $0x5a,%al
  80121c:	7f 30                	jg     80124e <strtol+0x126>
			dig = *s - 'A' + 10;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f be c0             	movsbl %al,%eax
  801226:	83 e8 37             	sub    $0x37,%eax
  801229:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80122c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801232:	7d 19                	jge    80124d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801234:	ff 45 08             	incl   0x8(%ebp)
  801237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80123e:	89 c2                	mov    %eax,%edx
  801240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801243:	01 d0                	add    %edx,%eax
  801245:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801248:	e9 7b ff ff ff       	jmp    8011c8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80124d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80124e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801252:	74 08                	je     80125c <strtol+0x134>
		*endptr = (char *) s;
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	8b 55 08             	mov    0x8(%ebp),%edx
  80125a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80125c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801260:	74 07                	je     801269 <strtol+0x141>
  801262:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801265:	f7 d8                	neg    %eax
  801267:	eb 03                	jmp    80126c <strtol+0x144>
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    

0080126e <ltostr>:

void
ltostr(long value, char *str)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801274:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80127b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801282:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801286:	79 13                	jns    80129b <ltostr+0x2d>
	{
		neg = 1;
  801288:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80128f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801292:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801295:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801298:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012a3:	99                   	cltd   
  8012a4:	f7 f9                	idiv   %ecx
  8012a6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ac:	8d 50 01             	lea    0x1(%eax),%edx
  8012af:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012b2:	89 c2                	mov    %eax,%edx
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	01 d0                	add    %edx,%eax
  8012b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012bc:	83 c2 30             	add    $0x30,%edx
  8012bf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012c9:	f7 e9                	imul   %ecx
  8012cb:	c1 fa 02             	sar    $0x2,%edx
  8012ce:	89 c8                	mov    %ecx,%eax
  8012d0:	c1 f8 1f             	sar    $0x1f,%eax
  8012d3:	29 c2                	sub    %eax,%edx
  8012d5:	89 d0                	mov    %edx,%eax
  8012d7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012dd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012e2:	f7 e9                	imul   %ecx
  8012e4:	c1 fa 02             	sar    $0x2,%edx
  8012e7:	89 c8                	mov    %ecx,%eax
  8012e9:	c1 f8 1f             	sar    $0x1f,%eax
  8012ec:	29 c2                	sub    %eax,%edx
  8012ee:	89 d0                	mov    %edx,%eax
  8012f0:	c1 e0 02             	shl    $0x2,%eax
  8012f3:	01 d0                	add    %edx,%eax
  8012f5:	01 c0                	add    %eax,%eax
  8012f7:	29 c1                	sub    %eax,%ecx
  8012f9:	89 ca                	mov    %ecx,%edx
  8012fb:	85 d2                	test   %edx,%edx
  8012fd:	75 9c                	jne    80129b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801306:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801309:	48                   	dec    %eax
  80130a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80130d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801311:	74 3d                	je     801350 <ltostr+0xe2>
		start = 1 ;
  801313:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80131a:	eb 34                	jmp    801350 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80131c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80131f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801322:	01 d0                	add    %edx,%eax
  801324:	8a 00                	mov    (%eax),%al
  801326:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	01 c2                	add    %eax,%edx
  801331:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	01 c8                	add    %ecx,%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80133d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	01 c2                	add    %eax,%edx
  801345:	8a 45 eb             	mov    -0x15(%ebp),%al
  801348:	88 02                	mov    %al,(%edx)
		start++ ;
  80134a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80134d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801353:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801356:	7c c4                	jl     80131c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801358:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	01 d0                	add    %edx,%eax
  801360:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801363:	90                   	nop
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80136c:	ff 75 08             	pushl  0x8(%ebp)
  80136f:	e8 54 fa ff ff       	call   800dc8 <strlen>
  801374:	83 c4 04             	add    $0x4,%esp
  801377:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80137a:	ff 75 0c             	pushl  0xc(%ebp)
  80137d:	e8 46 fa ff ff       	call   800dc8 <strlen>
  801382:	83 c4 04             	add    $0x4,%esp
  801385:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80138f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801396:	eb 17                	jmp    8013af <strcconcat+0x49>
		final[s] = str1[s] ;
  801398:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80139b:	8b 45 10             	mov    0x10(%ebp),%eax
  80139e:	01 c2                	add    %eax,%edx
  8013a0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	01 c8                	add    %ecx,%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013ac:	ff 45 fc             	incl   -0x4(%ebp)
  8013af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013b5:	7c e1                	jl     801398 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013c5:	eb 1f                	jmp    8013e6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ca:	8d 50 01             	lea    0x1(%eax),%edx
  8013cd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013d0:	89 c2                	mov    %eax,%edx
  8013d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d5:	01 c2                	add    %eax,%edx
  8013d7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	01 c8                	add    %ecx,%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013e3:	ff 45 f8             	incl   -0x8(%ebp)
  8013e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ec:	7c d9                	jl     8013c7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f4:	01 d0                	add    %edx,%eax
  8013f6:	c6 00 00             	movb   $0x0,(%eax)
}
  8013f9:	90                   	nop
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801402:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801408:	8b 45 14             	mov    0x14(%ebp),%eax
  80140b:	8b 00                	mov    (%eax),%eax
  80140d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801414:	8b 45 10             	mov    0x10(%ebp),%eax
  801417:	01 d0                	add    %edx,%eax
  801419:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80141f:	eb 0c                	jmp    80142d <strsplit+0x31>
			*string++ = 0;
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8d 50 01             	lea    0x1(%eax),%edx
  801427:	89 55 08             	mov    %edx,0x8(%ebp)
  80142a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	84 c0                	test   %al,%al
  801434:	74 18                	je     80144e <strsplit+0x52>
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	0f be c0             	movsbl %al,%eax
  80143e:	50                   	push   %eax
  80143f:	ff 75 0c             	pushl  0xc(%ebp)
  801442:	e8 13 fb ff ff       	call   800f5a <strchr>
  801447:	83 c4 08             	add    $0x8,%esp
  80144a:	85 c0                	test   %eax,%eax
  80144c:	75 d3                	jne    801421 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	74 5a                	je     8014b1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801457:	8b 45 14             	mov    0x14(%ebp),%eax
  80145a:	8b 00                	mov    (%eax),%eax
  80145c:	83 f8 0f             	cmp    $0xf,%eax
  80145f:	75 07                	jne    801468 <strsplit+0x6c>
		{
			return 0;
  801461:	b8 00 00 00 00       	mov    $0x0,%eax
  801466:	eb 66                	jmp    8014ce <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8d 48 01             	lea    0x1(%eax),%ecx
  801470:	8b 55 14             	mov    0x14(%ebp),%edx
  801473:	89 0a                	mov    %ecx,(%edx)
  801475:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80147c:	8b 45 10             	mov    0x10(%ebp),%eax
  80147f:	01 c2                	add    %eax,%edx
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801486:	eb 03                	jmp    80148b <strsplit+0x8f>
			string++;
  801488:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	84 c0                	test   %al,%al
  801492:	74 8b                	je     80141f <strsplit+0x23>
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	0f be c0             	movsbl %al,%eax
  80149c:	50                   	push   %eax
  80149d:	ff 75 0c             	pushl  0xc(%ebp)
  8014a0:	e8 b5 fa ff ff       	call   800f5a <strchr>
  8014a5:	83 c4 08             	add    $0x8,%esp
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	74 dc                	je     801488 <strsplit+0x8c>
			string++;
	}
  8014ac:	e9 6e ff ff ff       	jmp    80141f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014b1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b5:	8b 00                	mov    (%eax),%eax
  8014b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014be:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c1:	01 d0                	add    %edx,%eax
  8014c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  8014d6:	a1 28 30 80 00       	mov    0x803028,%eax
  8014db:	85 c0                	test   %eax,%eax
  8014dd:	75 33                	jne    801512 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  8014df:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  8014e6:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  8014e9:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  8014f0:	00 00 a0 
		spaces[0].pages = numPages;
  8014f3:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  8014fa:	00 02 00 
		spaces[0].isFree = 1;
  8014fd:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  801504:	00 00 00 
		arraySize++;
  801507:	a1 28 30 80 00       	mov    0x803028,%eax
  80150c:	40                   	inc    %eax
  80150d:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  801512:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  801519:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  801520:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801527:	8b 55 08             	mov    0x8(%ebp),%edx
  80152a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80152d:	01 d0                	add    %edx,%eax
  80152f:	48                   	dec    %eax
  801530:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801536:	ba 00 00 00 00       	mov    $0x0,%edx
  80153b:	f7 75 e8             	divl   -0x18(%ebp)
  80153e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801541:	29 d0                	sub    %edx,%eax
  801543:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	c1 e8 0c             	shr    $0xc,%eax
  80154c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  80154f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801556:	eb 57                	jmp    8015af <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  801558:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80155b:	c1 e0 04             	shl    $0x4,%eax
  80155e:	05 2c 31 80 00       	add    $0x80312c,%eax
  801563:	8b 00                	mov    (%eax),%eax
  801565:	85 c0                	test   %eax,%eax
  801567:	74 42                	je     8015ab <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  801569:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80156c:	c1 e0 04             	shl    $0x4,%eax
  80156f:	05 28 31 80 00       	add    $0x803128,%eax
  801574:	8b 00                	mov    (%eax),%eax
  801576:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801579:	7c 31                	jl     8015ac <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  80157b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157e:	c1 e0 04             	shl    $0x4,%eax
  801581:	05 28 31 80 00       	add    $0x803128,%eax
  801586:	8b 00                	mov    (%eax),%eax
  801588:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80158b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80158e:	7d 1c                	jge    8015ac <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  801590:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801593:	c1 e0 04             	shl    $0x4,%eax
  801596:	05 28 31 80 00       	add    $0x803128,%eax
  80159b:	8b 00                	mov    (%eax),%eax
  80159d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8015a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  8015a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015a9:	eb 01                	jmp    8015ac <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  8015ab:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  8015ac:	ff 45 ec             	incl   -0x14(%ebp)
  8015af:	a1 28 30 80 00       	mov    0x803028,%eax
  8015b4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8015b7:	7c 9f                	jl     801558 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  8015b9:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8015bd:	75 0a                	jne    8015c9 <malloc+0xf9>
	{
		return NULL;
  8015bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c4:	e9 34 01 00 00       	jmp    8016fd <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  8015c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cc:	c1 e0 04             	shl    $0x4,%eax
  8015cf:	05 28 31 80 00       	add    $0x803128,%eax
  8015d4:	8b 00                	mov    (%eax),%eax
  8015d6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8015d9:	75 38                	jne    801613 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  8015db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015de:	c1 e0 04             	shl    $0x4,%eax
  8015e1:	05 2c 31 80 00       	add    $0x80312c,%eax
  8015e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  8015ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ef:	c1 e0 0c             	shl    $0xc,%eax
  8015f2:	89 c2                	mov    %eax,%edx
  8015f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f7:	c1 e0 04             	shl    $0x4,%eax
  8015fa:	05 20 31 80 00       	add    $0x803120,%eax
  8015ff:	8b 00                	mov    (%eax),%eax
  801601:	83 ec 08             	sub    $0x8,%esp
  801604:	52                   	push   %edx
  801605:	50                   	push   %eax
  801606:	e8 01 06 00 00       	call   801c0c <sys_allocateMem>
  80160b:	83 c4 10             	add    $0x10,%esp
  80160e:	e9 dd 00 00 00       	jmp    8016f0 <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  801613:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801616:	c1 e0 04             	shl    $0x4,%eax
  801619:	05 20 31 80 00       	add    $0x803120,%eax
  80161e:	8b 00                	mov    (%eax),%eax
  801620:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801623:	c1 e2 0c             	shl    $0xc,%edx
  801626:	01 d0                	add    %edx,%eax
  801628:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  80162b:	a1 28 30 80 00       	mov    0x803028,%eax
  801630:	c1 e0 04             	shl    $0x4,%eax
  801633:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  801639:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80163c:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  80163e:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801647:	c1 e0 04             	shl    $0x4,%eax
  80164a:	05 24 31 80 00       	add    $0x803124,%eax
  80164f:	8b 00                	mov    (%eax),%eax
  801651:	c1 e2 04             	shl    $0x4,%edx
  801654:	81 c2 24 31 80 00    	add    $0x803124,%edx
  80165a:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  80165c:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801665:	c1 e0 04             	shl    $0x4,%eax
  801668:	05 28 31 80 00       	add    $0x803128,%eax
  80166d:	8b 00                	mov    (%eax),%eax
  80166f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801672:	c1 e2 04             	shl    $0x4,%edx
  801675:	81 c2 28 31 80 00    	add    $0x803128,%edx
  80167b:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  80167d:	a1 28 30 80 00       	mov    0x803028,%eax
  801682:	c1 e0 04             	shl    $0x4,%eax
  801685:	05 2c 31 80 00       	add    $0x80312c,%eax
  80168a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  801690:	a1 28 30 80 00       	mov    0x803028,%eax
  801695:	40                   	inc    %eax
  801696:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  80169b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169e:	c1 e0 04             	shl    $0x4,%eax
  8016a1:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  8016a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016aa:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  8016ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016af:	c1 e0 04             	shl    $0x4,%eax
  8016b2:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  8016b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016bb:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  8016bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c0:	c1 e0 04             	shl    $0x4,%eax
  8016c3:	05 2c 31 80 00       	add    $0x80312c,%eax
  8016c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  8016ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d1:	c1 e0 0c             	shl    $0xc,%eax
  8016d4:	89 c2                	mov    %eax,%edx
  8016d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d9:	c1 e0 04             	shl    $0x4,%eax
  8016dc:	05 20 31 80 00       	add    $0x803120,%eax
  8016e1:	8b 00                	mov    (%eax),%eax
  8016e3:	83 ec 08             	sub    $0x8,%esp
  8016e6:	52                   	push   %edx
  8016e7:	50                   	push   %eax
  8016e8:	e8 1f 05 00 00       	call   801c0c <sys_allocateMem>
  8016ed:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  8016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f3:	c1 e0 04             	shl    $0x4,%eax
  8016f6:	05 20 31 80 00       	add    $0x803120,%eax
  8016fb:	8b 00                	mov    (%eax),%eax
	}


}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  801705:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  80170c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801713:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80171a:	eb 3f                	jmp    80175b <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  80171c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171f:	c1 e0 04             	shl    $0x4,%eax
  801722:	05 20 31 80 00       	add    $0x803120,%eax
  801727:	8b 00                	mov    (%eax),%eax
  801729:	3b 45 08             	cmp    0x8(%ebp),%eax
  80172c:	75 2a                	jne    801758 <free+0x59>
		{
			index=i;
  80172e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801731:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  801734:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801737:	c1 e0 04             	shl    $0x4,%eax
  80173a:	05 28 31 80 00       	add    $0x803128,%eax
  80173f:	8b 00                	mov    (%eax),%eax
  801741:	c1 e0 0c             	shl    $0xc,%eax
  801744:	89 c2                	mov    %eax,%edx
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	83 ec 08             	sub    $0x8,%esp
  80174c:	52                   	push   %edx
  80174d:	50                   	push   %eax
  80174e:	e8 9d 04 00 00       	call   801bf0 <sys_freeMem>
  801753:	83 c4 10             	add    $0x10,%esp
			break;
  801756:	eb 0d                	jmp    801765 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  801758:	ff 45 ec             	incl   -0x14(%ebp)
  80175b:	a1 28 30 80 00       	mov    0x803028,%eax
  801760:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801763:	7c b7                	jl     80171c <free+0x1d>
			break;
		}

	}

	if(index == -1)
  801765:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801769:	75 17                	jne    801782 <free+0x83>
	{
		panic("Error");
  80176b:	83 ec 04             	sub    $0x4,%esp
  80176e:	68 90 29 80 00       	push   $0x802990
  801773:	68 81 00 00 00       	push   $0x81
  801778:	68 96 29 80 00       	push   $0x802996
  80177d:	e8 14 09 00 00       	call   802096 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  801782:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801789:	e9 cc 00 00 00       	jmp    80185a <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  80178e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801791:	c1 e0 04             	shl    $0x4,%eax
  801794:	05 2c 31 80 00       	add    $0x80312c,%eax
  801799:	8b 00                	mov    (%eax),%eax
  80179b:	85 c0                	test   %eax,%eax
  80179d:	0f 84 b3 00 00 00    	je     801856 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  8017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a6:	c1 e0 04             	shl    $0x4,%eax
  8017a9:	05 20 31 80 00       	add    $0x803120,%eax
  8017ae:	8b 10                	mov    (%eax),%edx
  8017b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b3:	c1 e0 04             	shl    $0x4,%eax
  8017b6:	05 24 31 80 00       	add    $0x803124,%eax
  8017bb:	8b 00                	mov    (%eax),%eax
  8017bd:	39 c2                	cmp    %eax,%edx
  8017bf:	0f 85 92 00 00 00    	jne    801857 <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  8017c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c8:	c1 e0 04             	shl    $0x4,%eax
  8017cb:	05 24 31 80 00       	add    $0x803124,%eax
  8017d0:	8b 00                	mov    (%eax),%eax
  8017d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017d5:	c1 e2 04             	shl    $0x4,%edx
  8017d8:	81 c2 24 31 80 00    	add    $0x803124,%edx
  8017de:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  8017e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017e3:	c1 e0 04             	shl    $0x4,%eax
  8017e6:	05 28 31 80 00       	add    $0x803128,%eax
  8017eb:	8b 10                	mov    (%eax),%edx
  8017ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f0:	c1 e0 04             	shl    $0x4,%eax
  8017f3:	05 28 31 80 00       	add    $0x803128,%eax
  8017f8:	8b 00                	mov    (%eax),%eax
  8017fa:	01 c2                	add    %eax,%edx
  8017fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ff:	c1 e0 04             	shl    $0x4,%eax
  801802:	05 28 31 80 00       	add    $0x803128,%eax
  801807:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180c:	c1 e0 04             	shl    $0x4,%eax
  80180f:	05 20 31 80 00       	add    $0x803120,%eax
  801814:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  80181a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181d:	c1 e0 04             	shl    $0x4,%eax
  801820:	05 24 31 80 00       	add    $0x803124,%eax
  801825:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  80182b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182e:	c1 e0 04             	shl    $0x4,%eax
  801831:	05 28 31 80 00       	add    $0x803128,%eax
  801836:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  80183c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183f:	c1 e0 04             	shl    $0x4,%eax
  801842:	05 2c 31 80 00       	add    $0x80312c,%eax
  801847:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  80184d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801854:	eb 12                	jmp    801868 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801856:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801857:	ff 45 e8             	incl   -0x18(%ebp)
  80185a:	a1 28 30 80 00       	mov    0x803028,%eax
  80185f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801862:	0f 8c 26 ff ff ff    	jl     80178e <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801868:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80186f:	e9 cc 00 00 00       	jmp    801940 <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  801874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801877:	c1 e0 04             	shl    $0x4,%eax
  80187a:	05 2c 31 80 00       	add    $0x80312c,%eax
  80187f:	8b 00                	mov    (%eax),%eax
  801881:	85 c0                	test   %eax,%eax
  801883:	0f 84 b3 00 00 00    	je     80193c <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  801889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188c:	c1 e0 04             	shl    $0x4,%eax
  80188f:	05 24 31 80 00       	add    $0x803124,%eax
  801894:	8b 10                	mov    (%eax),%edx
  801896:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801899:	c1 e0 04             	shl    $0x4,%eax
  80189c:	05 20 31 80 00       	add    $0x803120,%eax
  8018a1:	8b 00                	mov    (%eax),%eax
  8018a3:	39 c2                	cmp    %eax,%edx
  8018a5:	0f 85 92 00 00 00    	jne    80193d <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  8018ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ae:	c1 e0 04             	shl    $0x4,%eax
  8018b1:	05 20 31 80 00       	add    $0x803120,%eax
  8018b6:	8b 00                	mov    (%eax),%eax
  8018b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018bb:	c1 e2 04             	shl    $0x4,%edx
  8018be:	81 c2 20 31 80 00    	add    $0x803120,%edx
  8018c4:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  8018c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018c9:	c1 e0 04             	shl    $0x4,%eax
  8018cc:	05 28 31 80 00       	add    $0x803128,%eax
  8018d1:	8b 10                	mov    (%eax),%edx
  8018d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d6:	c1 e0 04             	shl    $0x4,%eax
  8018d9:	05 28 31 80 00       	add    $0x803128,%eax
  8018de:	8b 00                	mov    (%eax),%eax
  8018e0:	01 c2                	add    %eax,%edx
  8018e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018e5:	c1 e0 04             	shl    $0x4,%eax
  8018e8:	05 28 31 80 00       	add    $0x803128,%eax
  8018ed:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  8018ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f2:	c1 e0 04             	shl    $0x4,%eax
  8018f5:	05 20 31 80 00       	add    $0x803120,%eax
  8018fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801903:	c1 e0 04             	shl    $0x4,%eax
  801906:	05 24 31 80 00       	add    $0x803124,%eax
  80190b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801914:	c1 e0 04             	shl    $0x4,%eax
  801917:	05 28 31 80 00       	add    $0x803128,%eax
  80191c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801925:	c1 e0 04             	shl    $0x4,%eax
  801928:	05 2c 31 80 00       	add    $0x80312c,%eax
  80192d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801933:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  80193a:	eb 12                	jmp    80194e <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  80193c:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  80193d:	ff 45 e4             	incl   -0x1c(%ebp)
  801940:	a1 28 30 80 00       	mov    0x803028,%eax
  801945:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801948:	0f 8c 26 ff ff ff    	jl     801874 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  80194e:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801952:	75 11                	jne    801965 <free+0x266>
	{
		spaces[index].isFree = 1;
  801954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801957:	c1 e0 04             	shl    $0x4,%eax
  80195a:	05 2c 31 80 00       	add    $0x80312c,%eax
  80195f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  801965:	90                   	nop
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
  80196b:	83 ec 18             	sub    $0x18,%esp
  80196e:	8b 45 10             	mov    0x10(%ebp),%eax
  801971:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801974:	83 ec 04             	sub    $0x4,%esp
  801977:	68 a4 29 80 00       	push   $0x8029a4
  80197c:	68 b9 00 00 00       	push   $0xb9
  801981:	68 96 29 80 00       	push   $0x802996
  801986:	e8 0b 07 00 00       	call   802096 <_panic>

0080198b <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	68 a4 29 80 00       	push   $0x8029a4
  801999:	68 bf 00 00 00       	push   $0xbf
  80199e:	68 96 29 80 00       	push   $0x802996
  8019a3:	e8 ee 06 00 00       	call   802096 <_panic>

008019a8 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019ae:	83 ec 04             	sub    $0x4,%esp
  8019b1:	68 a4 29 80 00       	push   $0x8029a4
  8019b6:	68 c5 00 00 00       	push   $0xc5
  8019bb:	68 96 29 80 00       	push   $0x802996
  8019c0:	e8 d1 06 00 00       	call   802096 <_panic>

008019c5 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
  8019c8:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	68 a4 29 80 00       	push   $0x8029a4
  8019d3:	68 ca 00 00 00       	push   $0xca
  8019d8:	68 96 29 80 00       	push   $0x802996
  8019dd:	e8 b4 06 00 00       	call   802096 <_panic>

008019e2 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019e8:	83 ec 04             	sub    $0x4,%esp
  8019eb:	68 a4 29 80 00       	push   $0x8029a4
  8019f0:	68 d0 00 00 00       	push   $0xd0
  8019f5:	68 96 29 80 00       	push   $0x802996
  8019fa:	e8 97 06 00 00       	call   802096 <_panic>

008019ff <shrink>:
}
void shrink(uint32 newSize)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a05:	83 ec 04             	sub    $0x4,%esp
  801a08:	68 a4 29 80 00       	push   $0x8029a4
  801a0d:	68 d4 00 00 00       	push   $0xd4
  801a12:	68 96 29 80 00       	push   $0x802996
  801a17:	e8 7a 06 00 00       	call   802096 <_panic>

00801a1c <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a22:	83 ec 04             	sub    $0x4,%esp
  801a25:	68 a4 29 80 00       	push   $0x8029a4
  801a2a:	68 d9 00 00 00       	push   $0xd9
  801a2f:	68 96 29 80 00       	push   $0x802996
  801a34:	e8 5d 06 00 00       	call   802096 <_panic>

00801a39 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	57                   	push   %edi
  801a3d:	56                   	push   %esi
  801a3e:	53                   	push   %ebx
  801a3f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a4e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a51:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a54:	cd 30                	int    $0x30
  801a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a5c:	83 c4 10             	add    $0x10,%esp
  801a5f:	5b                   	pop    %ebx
  801a60:	5e                   	pop    %esi
  801a61:	5f                   	pop    %edi
  801a62:	5d                   	pop    %ebp
  801a63:	c3                   	ret    

00801a64 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 04             	sub    $0x4,%esp
  801a6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a70:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	52                   	push   %edx
  801a7c:	ff 75 0c             	pushl  0xc(%ebp)
  801a7f:	50                   	push   %eax
  801a80:	6a 00                	push   $0x0
  801a82:	e8 b2 ff ff ff       	call   801a39 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	90                   	nop
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_cgetc>:

int
sys_cgetc(void)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 01                	push   $0x1
  801a9c:	e8 98 ff ff ff       	call   801a39 <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	50                   	push   %eax
  801ab5:	6a 05                	push   $0x5
  801ab7:	e8 7d ff ff ff       	call   801a39 <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 02                	push   $0x2
  801ad0:	e8 64 ff ff ff       	call   801a39 <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 03                	push   $0x3
  801ae9:	e8 4b ff ff ff       	call   801a39 <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 04                	push   $0x4
  801b02:	e8 32 ff ff ff       	call   801a39 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
}
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_env_exit>:


void sys_env_exit(void)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 06                	push   $0x6
  801b1b:	e8 19 ff ff ff       	call   801a39 <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	90                   	nop
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	52                   	push   %edx
  801b36:	50                   	push   %eax
  801b37:	6a 07                	push   $0x7
  801b39:	e8 fb fe ff ff       	call   801a39 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b48:	8b 75 18             	mov    0x18(%ebp),%esi
  801b4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	56                   	push   %esi
  801b58:	53                   	push   %ebx
  801b59:	51                   	push   %ecx
  801b5a:	52                   	push   %edx
  801b5b:	50                   	push   %eax
  801b5c:	6a 08                	push   $0x8
  801b5e:	e8 d6 fe ff ff       	call   801a39 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b69:	5b                   	pop    %ebx
  801b6a:	5e                   	pop    %esi
  801b6b:	5d                   	pop    %ebp
  801b6c:	c3                   	ret    

00801b6d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	52                   	push   %edx
  801b7d:	50                   	push   %eax
  801b7e:	6a 09                	push   $0x9
  801b80:	e8 b4 fe ff ff       	call   801a39 <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	ff 75 0c             	pushl  0xc(%ebp)
  801b96:	ff 75 08             	pushl  0x8(%ebp)
  801b99:	6a 0a                	push   $0xa
  801b9b:	e8 99 fe ff ff       	call   801a39 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 0b                	push   $0xb
  801bb4:	e8 80 fe ff ff       	call   801a39 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 0c                	push   $0xc
  801bcd:	e8 67 fe ff ff       	call   801a39 <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 0d                	push   $0xd
  801be6:	e8 4e fe ff ff       	call   801a39 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	ff 75 0c             	pushl  0xc(%ebp)
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	6a 11                	push   $0x11
  801c01:	e8 33 fe ff ff       	call   801a39 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
	return;
  801c09:	90                   	nop
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	ff 75 0c             	pushl  0xc(%ebp)
  801c18:	ff 75 08             	pushl  0x8(%ebp)
  801c1b:	6a 12                	push   $0x12
  801c1d:	e8 17 fe ff ff       	call   801a39 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
	return ;
  801c25:	90                   	nop
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 0e                	push   $0xe
  801c37:	e8 fd fd ff ff       	call   801a39 <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	ff 75 08             	pushl  0x8(%ebp)
  801c4f:	6a 0f                	push   $0xf
  801c51:	e8 e3 fd ff ff       	call   801a39 <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 10                	push   $0x10
  801c6a:	e8 ca fd ff ff       	call   801a39 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
}
  801c72:	90                   	nop
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 14                	push   $0x14
  801c84:	e8 b0 fd ff ff       	call   801a39 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
}
  801c8c:	90                   	nop
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 15                	push   $0x15
  801c9e:	e8 96 fd ff ff       	call   801a39 <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
}
  801ca6:	90                   	nop
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	83 ec 04             	sub    $0x4,%esp
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cb5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	50                   	push   %eax
  801cc2:	6a 16                	push   $0x16
  801cc4:	e8 70 fd ff ff       	call   801a39 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
}
  801ccc:	90                   	nop
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 17                	push   $0x17
  801cde:	e8 56 fd ff ff       	call   801a39 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	90                   	nop
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cec:	8b 45 08             	mov    0x8(%ebp),%eax
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	ff 75 0c             	pushl  0xc(%ebp)
  801cf8:	50                   	push   %eax
  801cf9:	6a 18                	push   $0x18
  801cfb:	e8 39 fd ff ff       	call   801a39 <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	52                   	push   %edx
  801d15:	50                   	push   %eax
  801d16:	6a 1b                	push   $0x1b
  801d18:	e8 1c fd ff ff       	call   801a39 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	52                   	push   %edx
  801d32:	50                   	push   %eax
  801d33:	6a 19                	push   $0x19
  801d35:	e8 ff fc ff ff       	call   801a39 <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
}
  801d3d:	90                   	nop
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	52                   	push   %edx
  801d50:	50                   	push   %eax
  801d51:	6a 1a                	push   $0x1a
  801d53:	e8 e1 fc ff ff       	call   801a39 <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	90                   	nop
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 04             	sub    $0x4,%esp
  801d64:	8b 45 10             	mov    0x10(%ebp),%eax
  801d67:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d6a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d6d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	6a 00                	push   $0x0
  801d76:	51                   	push   %ecx
  801d77:	52                   	push   %edx
  801d78:	ff 75 0c             	pushl  0xc(%ebp)
  801d7b:	50                   	push   %eax
  801d7c:	6a 1c                	push   $0x1c
  801d7e:	e8 b6 fc ff ff       	call   801a39 <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	52                   	push   %edx
  801d98:	50                   	push   %eax
  801d99:	6a 1d                	push   $0x1d
  801d9b:	e8 99 fc ff ff       	call   801a39 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801da8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dae:	8b 45 08             	mov    0x8(%ebp),%eax
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	51                   	push   %ecx
  801db6:	52                   	push   %edx
  801db7:	50                   	push   %eax
  801db8:	6a 1e                	push   $0x1e
  801dba:	e8 7a fc ff ff       	call   801a39 <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801dc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	52                   	push   %edx
  801dd4:	50                   	push   %eax
  801dd5:	6a 1f                	push   $0x1f
  801dd7:	e8 5d fc ff ff       	call   801a39 <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 20                	push   $0x20
  801df0:	e8 44 fc ff ff       	call   801a39 <syscall>
  801df5:	83 c4 18             	add    $0x18,%esp
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	6a 00                	push   $0x0
  801e02:	ff 75 14             	pushl  0x14(%ebp)
  801e05:	ff 75 10             	pushl  0x10(%ebp)
  801e08:	ff 75 0c             	pushl  0xc(%ebp)
  801e0b:	50                   	push   %eax
  801e0c:	6a 21                	push   $0x21
  801e0e:	e8 26 fc ff ff       	call   801a39 <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	50                   	push   %eax
  801e27:	6a 22                	push   $0x22
  801e29:	e8 0b fc ff ff       	call   801a39 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
}
  801e31:	90                   	nop
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	50                   	push   %eax
  801e43:	6a 23                	push   $0x23
  801e45:	e8 ef fb ff ff       	call   801a39 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
}
  801e4d:	90                   	nop
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e56:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e59:	8d 50 04             	lea    0x4(%eax),%edx
  801e5c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	52                   	push   %edx
  801e66:	50                   	push   %eax
  801e67:	6a 24                	push   $0x24
  801e69:	e8 cb fb ff ff       	call   801a39 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
	return result;
  801e71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e7a:	89 01                	mov    %eax,(%ecx)
  801e7c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	c9                   	leave  
  801e83:	c2 04 00             	ret    $0x4

00801e86 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	ff 75 10             	pushl  0x10(%ebp)
  801e90:	ff 75 0c             	pushl  0xc(%ebp)
  801e93:	ff 75 08             	pushl  0x8(%ebp)
  801e96:	6a 13                	push   $0x13
  801e98:	e8 9c fb ff ff       	call   801a39 <syscall>
  801e9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea0:	90                   	nop
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 25                	push   $0x25
  801eb2:	e8 82 fb ff ff       	call   801a39 <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
}
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	83 ec 04             	sub    $0x4,%esp
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ec8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	50                   	push   %eax
  801ed5:	6a 26                	push   $0x26
  801ed7:	e8 5d fb ff ff       	call   801a39 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
	return ;
  801edf:	90                   	nop
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <rsttst>:
void rsttst()
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 28                	push   $0x28
  801ef1:	e8 43 fb ff ff       	call   801a39 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef9:	90                   	nop
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 04             	sub    $0x4,%esp
  801f02:	8b 45 14             	mov    0x14(%ebp),%eax
  801f05:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f08:	8b 55 18             	mov    0x18(%ebp),%edx
  801f0b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f0f:	52                   	push   %edx
  801f10:	50                   	push   %eax
  801f11:	ff 75 10             	pushl  0x10(%ebp)
  801f14:	ff 75 0c             	pushl  0xc(%ebp)
  801f17:	ff 75 08             	pushl  0x8(%ebp)
  801f1a:	6a 27                	push   $0x27
  801f1c:	e8 18 fb ff ff       	call   801a39 <syscall>
  801f21:	83 c4 18             	add    $0x18,%esp
	return ;
  801f24:	90                   	nop
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <chktst>:
void chktst(uint32 n)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	ff 75 08             	pushl  0x8(%ebp)
  801f35:	6a 29                	push   $0x29
  801f37:	e8 fd fa ff ff       	call   801a39 <syscall>
  801f3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f3f:	90                   	nop
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <inctst>:

void inctst()
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 2a                	push   $0x2a
  801f51:	e8 e3 fa ff ff       	call   801a39 <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
	return ;
  801f59:	90                   	nop
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <gettst>:
uint32 gettst()
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 2b                	push   $0x2b
  801f6b:	e8 c9 fa ff ff       	call   801a39 <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 2c                	push   $0x2c
  801f87:	e8 ad fa ff ff       	call   801a39 <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
  801f8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f92:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f96:	75 07                	jne    801f9f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f98:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9d:	eb 05                	jmp    801fa4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 2c                	push   $0x2c
  801fb8:	e8 7c fa ff ff       	call   801a39 <syscall>
  801fbd:	83 c4 18             	add    $0x18,%esp
  801fc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fc3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fc7:	75 07                	jne    801fd0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fc9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fce:	eb 05                	jmp    801fd5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 2c                	push   $0x2c
  801fe9:	e8 4b fa ff ff       	call   801a39 <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
  801ff1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ff4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ff8:	75 07                	jne    802001 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ffa:	b8 01 00 00 00       	mov    $0x1,%eax
  801fff:	eb 05                	jmp    802006 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802001:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 2c                	push   $0x2c
  80201a:	e8 1a fa ff ff       	call   801a39 <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
  802022:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802025:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802029:	75 07                	jne    802032 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80202b:	b8 01 00 00 00       	mov    $0x1,%eax
  802030:	eb 05                	jmp    802037 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802032:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	ff 75 08             	pushl  0x8(%ebp)
  802047:	6a 2d                	push   $0x2d
  802049:	e8 eb f9 ff ff       	call   801a39 <syscall>
  80204e:	83 c4 18             	add    $0x18,%esp
	return ;
  802051:	90                   	nop
}
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802058:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80205b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80205e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802061:	8b 45 08             	mov    0x8(%ebp),%eax
  802064:	6a 00                	push   $0x0
  802066:	53                   	push   %ebx
  802067:	51                   	push   %ecx
  802068:	52                   	push   %edx
  802069:	50                   	push   %eax
  80206a:	6a 2e                	push   $0x2e
  80206c:	e8 c8 f9 ff ff       	call   801a39 <syscall>
  802071:	83 c4 18             	add    $0x18,%esp
}
  802074:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80207c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	52                   	push   %edx
  802089:	50                   	push   %eax
  80208a:	6a 2f                	push   $0x2f
  80208c:	e8 a8 f9 ff ff       	call   801a39 <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80209c:	8d 45 10             	lea    0x10(%ebp),%eax
  80209f:	83 c0 04             	add    $0x4,%eax
  8020a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8020a5:	a1 20 31 a0 00       	mov    0xa03120,%eax
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	74 16                	je     8020c4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8020ae:	a1 20 31 a0 00       	mov    0xa03120,%eax
  8020b3:	83 ec 08             	sub    $0x8,%esp
  8020b6:	50                   	push   %eax
  8020b7:	68 c8 29 80 00       	push   $0x8029c8
  8020bc:	e8 85 e6 ff ff       	call   800746 <cprintf>
  8020c1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8020c4:	a1 00 30 80 00       	mov    0x803000,%eax
  8020c9:	ff 75 0c             	pushl  0xc(%ebp)
  8020cc:	ff 75 08             	pushl  0x8(%ebp)
  8020cf:	50                   	push   %eax
  8020d0:	68 cd 29 80 00       	push   $0x8029cd
  8020d5:	e8 6c e6 ff ff       	call   800746 <cprintf>
  8020da:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8020dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e0:	83 ec 08             	sub    $0x8,%esp
  8020e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e6:	50                   	push   %eax
  8020e7:	e8 ef e5 ff ff       	call   8006db <vcprintf>
  8020ec:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8020ef:	83 ec 08             	sub    $0x8,%esp
  8020f2:	6a 00                	push   $0x0
  8020f4:	68 e9 29 80 00       	push   $0x8029e9
  8020f9:	e8 dd e5 ff ff       	call   8006db <vcprintf>
  8020fe:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802101:	e8 5e e5 ff ff       	call   800664 <exit>

	// should not return here
	while (1) ;
  802106:	eb fe                	jmp    802106 <_panic+0x70>

00802108 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80210e:	a1 20 30 80 00       	mov    0x803020,%eax
  802113:	8b 50 74             	mov    0x74(%eax),%edx
  802116:	8b 45 0c             	mov    0xc(%ebp),%eax
  802119:	39 c2                	cmp    %eax,%edx
  80211b:	74 14                	je     802131 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80211d:	83 ec 04             	sub    $0x4,%esp
  802120:	68 ec 29 80 00       	push   $0x8029ec
  802125:	6a 26                	push   $0x26
  802127:	68 38 2a 80 00       	push   $0x802a38
  80212c:	e8 65 ff ff ff       	call   802096 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802131:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802138:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80213f:	e9 b6 00 00 00       	jmp    8021fa <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  802144:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802147:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	01 d0                	add    %edx,%eax
  802153:	8b 00                	mov    (%eax),%eax
  802155:	85 c0                	test   %eax,%eax
  802157:	75 08                	jne    802161 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802159:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80215c:	e9 96 00 00 00       	jmp    8021f7 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  802161:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802168:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80216f:	eb 5d                	jmp    8021ce <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802171:	a1 20 30 80 00       	mov    0x803020,%eax
  802176:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80217c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80217f:	c1 e2 04             	shl    $0x4,%edx
  802182:	01 d0                	add    %edx,%eax
  802184:	8a 40 04             	mov    0x4(%eax),%al
  802187:	84 c0                	test   %al,%al
  802189:	75 40                	jne    8021cb <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80218b:	a1 20 30 80 00       	mov    0x803020,%eax
  802190:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802196:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802199:	c1 e2 04             	shl    $0x4,%edx
  80219c:	01 d0                	add    %edx,%eax
  80219e:	8b 00                	mov    (%eax),%eax
  8021a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8021a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8021ab:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8021ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	01 c8                	add    %ecx,%eax
  8021bc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8021be:	39 c2                	cmp    %eax,%edx
  8021c0:	75 09                	jne    8021cb <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8021c2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8021c9:	eb 12                	jmp    8021dd <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8021cb:	ff 45 e8             	incl   -0x18(%ebp)
  8021ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8021d3:	8b 50 74             	mov    0x74(%eax),%edx
  8021d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021d9:	39 c2                	cmp    %eax,%edx
  8021db:	77 94                	ja     802171 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8021dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021e1:	75 14                	jne    8021f7 <CheckWSWithoutLastIndex+0xef>
			panic(
  8021e3:	83 ec 04             	sub    $0x4,%esp
  8021e6:	68 44 2a 80 00       	push   $0x802a44
  8021eb:	6a 3a                	push   $0x3a
  8021ed:	68 38 2a 80 00       	push   $0x802a38
  8021f2:	e8 9f fe ff ff       	call   802096 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8021f7:	ff 45 f0             	incl   -0x10(%ebp)
  8021fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802200:	0f 8c 3e ff ff ff    	jl     802144 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802206:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80220d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802214:	eb 20                	jmp    802236 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802216:	a1 20 30 80 00       	mov    0x803020,%eax
  80221b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802221:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802224:	c1 e2 04             	shl    $0x4,%edx
  802227:	01 d0                	add    %edx,%eax
  802229:	8a 40 04             	mov    0x4(%eax),%al
  80222c:	3c 01                	cmp    $0x1,%al
  80222e:	75 03                	jne    802233 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  802230:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802233:	ff 45 e0             	incl   -0x20(%ebp)
  802236:	a1 20 30 80 00       	mov    0x803020,%eax
  80223b:	8b 50 74             	mov    0x74(%eax),%edx
  80223e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802241:	39 c2                	cmp    %eax,%edx
  802243:	77 d1                	ja     802216 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802248:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80224b:	74 14                	je     802261 <CheckWSWithoutLastIndex+0x159>
		panic(
  80224d:	83 ec 04             	sub    $0x4,%esp
  802250:	68 98 2a 80 00       	push   $0x802a98
  802255:	6a 44                	push   $0x44
  802257:	68 38 2a 80 00       	push   $0x802a38
  80225c:	e8 35 fe ff ff       	call   802096 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802261:	90                   	nop
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <__udivdi3>:
  802264:	55                   	push   %ebp
  802265:	57                   	push   %edi
  802266:	56                   	push   %esi
  802267:	53                   	push   %ebx
  802268:	83 ec 1c             	sub    $0x1c,%esp
  80226b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80226f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802273:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802277:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80227b:	89 ca                	mov    %ecx,%edx
  80227d:	89 f8                	mov    %edi,%eax
  80227f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802283:	85 f6                	test   %esi,%esi
  802285:	75 2d                	jne    8022b4 <__udivdi3+0x50>
  802287:	39 cf                	cmp    %ecx,%edi
  802289:	77 65                	ja     8022f0 <__udivdi3+0x8c>
  80228b:	89 fd                	mov    %edi,%ebp
  80228d:	85 ff                	test   %edi,%edi
  80228f:	75 0b                	jne    80229c <__udivdi3+0x38>
  802291:	b8 01 00 00 00       	mov    $0x1,%eax
  802296:	31 d2                	xor    %edx,%edx
  802298:	f7 f7                	div    %edi
  80229a:	89 c5                	mov    %eax,%ebp
  80229c:	31 d2                	xor    %edx,%edx
  80229e:	89 c8                	mov    %ecx,%eax
  8022a0:	f7 f5                	div    %ebp
  8022a2:	89 c1                	mov    %eax,%ecx
  8022a4:	89 d8                	mov    %ebx,%eax
  8022a6:	f7 f5                	div    %ebp
  8022a8:	89 cf                	mov    %ecx,%edi
  8022aa:	89 fa                	mov    %edi,%edx
  8022ac:	83 c4 1c             	add    $0x1c,%esp
  8022af:	5b                   	pop    %ebx
  8022b0:	5e                   	pop    %esi
  8022b1:	5f                   	pop    %edi
  8022b2:	5d                   	pop    %ebp
  8022b3:	c3                   	ret    
  8022b4:	39 ce                	cmp    %ecx,%esi
  8022b6:	77 28                	ja     8022e0 <__udivdi3+0x7c>
  8022b8:	0f bd fe             	bsr    %esi,%edi
  8022bb:	83 f7 1f             	xor    $0x1f,%edi
  8022be:	75 40                	jne    802300 <__udivdi3+0x9c>
  8022c0:	39 ce                	cmp    %ecx,%esi
  8022c2:	72 0a                	jb     8022ce <__udivdi3+0x6a>
  8022c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8022c8:	0f 87 9e 00 00 00    	ja     80236c <__udivdi3+0x108>
  8022ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d3:	89 fa                	mov    %edi,%edx
  8022d5:	83 c4 1c             	add    $0x1c,%esp
  8022d8:	5b                   	pop    %ebx
  8022d9:	5e                   	pop    %esi
  8022da:	5f                   	pop    %edi
  8022db:	5d                   	pop    %ebp
  8022dc:	c3                   	ret    
  8022dd:	8d 76 00             	lea    0x0(%esi),%esi
  8022e0:	31 ff                	xor    %edi,%edi
  8022e2:	31 c0                	xor    %eax,%eax
  8022e4:	89 fa                	mov    %edi,%edx
  8022e6:	83 c4 1c             	add    $0x1c,%esp
  8022e9:	5b                   	pop    %ebx
  8022ea:	5e                   	pop    %esi
  8022eb:	5f                   	pop    %edi
  8022ec:	5d                   	pop    %ebp
  8022ed:	c3                   	ret    
  8022ee:	66 90                	xchg   %ax,%ax
  8022f0:	89 d8                	mov    %ebx,%eax
  8022f2:	f7 f7                	div    %edi
  8022f4:	31 ff                	xor    %edi,%edi
  8022f6:	89 fa                	mov    %edi,%edx
  8022f8:	83 c4 1c             	add    $0x1c,%esp
  8022fb:	5b                   	pop    %ebx
  8022fc:	5e                   	pop    %esi
  8022fd:	5f                   	pop    %edi
  8022fe:	5d                   	pop    %ebp
  8022ff:	c3                   	ret    
  802300:	bd 20 00 00 00       	mov    $0x20,%ebp
  802305:	89 eb                	mov    %ebp,%ebx
  802307:	29 fb                	sub    %edi,%ebx
  802309:	89 f9                	mov    %edi,%ecx
  80230b:	d3 e6                	shl    %cl,%esi
  80230d:	89 c5                	mov    %eax,%ebp
  80230f:	88 d9                	mov    %bl,%cl
  802311:	d3 ed                	shr    %cl,%ebp
  802313:	89 e9                	mov    %ebp,%ecx
  802315:	09 f1                	or     %esi,%ecx
  802317:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80231b:	89 f9                	mov    %edi,%ecx
  80231d:	d3 e0                	shl    %cl,%eax
  80231f:	89 c5                	mov    %eax,%ebp
  802321:	89 d6                	mov    %edx,%esi
  802323:	88 d9                	mov    %bl,%cl
  802325:	d3 ee                	shr    %cl,%esi
  802327:	89 f9                	mov    %edi,%ecx
  802329:	d3 e2                	shl    %cl,%edx
  80232b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80232f:	88 d9                	mov    %bl,%cl
  802331:	d3 e8                	shr    %cl,%eax
  802333:	09 c2                	or     %eax,%edx
  802335:	89 d0                	mov    %edx,%eax
  802337:	89 f2                	mov    %esi,%edx
  802339:	f7 74 24 0c          	divl   0xc(%esp)
  80233d:	89 d6                	mov    %edx,%esi
  80233f:	89 c3                	mov    %eax,%ebx
  802341:	f7 e5                	mul    %ebp
  802343:	39 d6                	cmp    %edx,%esi
  802345:	72 19                	jb     802360 <__udivdi3+0xfc>
  802347:	74 0b                	je     802354 <__udivdi3+0xf0>
  802349:	89 d8                	mov    %ebx,%eax
  80234b:	31 ff                	xor    %edi,%edi
  80234d:	e9 58 ff ff ff       	jmp    8022aa <__udivdi3+0x46>
  802352:	66 90                	xchg   %ax,%ax
  802354:	8b 54 24 08          	mov    0x8(%esp),%edx
  802358:	89 f9                	mov    %edi,%ecx
  80235a:	d3 e2                	shl    %cl,%edx
  80235c:	39 c2                	cmp    %eax,%edx
  80235e:	73 e9                	jae    802349 <__udivdi3+0xe5>
  802360:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802363:	31 ff                	xor    %edi,%edi
  802365:	e9 40 ff ff ff       	jmp    8022aa <__udivdi3+0x46>
  80236a:	66 90                	xchg   %ax,%ax
  80236c:	31 c0                	xor    %eax,%eax
  80236e:	e9 37 ff ff ff       	jmp    8022aa <__udivdi3+0x46>
  802373:	90                   	nop

00802374 <__umoddi3>:
  802374:	55                   	push   %ebp
  802375:	57                   	push   %edi
  802376:	56                   	push   %esi
  802377:	53                   	push   %ebx
  802378:	83 ec 1c             	sub    $0x1c,%esp
  80237b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80237f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802383:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802387:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80238b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80238f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802393:	89 f3                	mov    %esi,%ebx
  802395:	89 fa                	mov    %edi,%edx
  802397:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80239b:	89 34 24             	mov    %esi,(%esp)
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	75 1a                	jne    8023bc <__umoddi3+0x48>
  8023a2:	39 f7                	cmp    %esi,%edi
  8023a4:	0f 86 a2 00 00 00    	jbe    80244c <__umoddi3+0xd8>
  8023aa:	89 c8                	mov    %ecx,%eax
  8023ac:	89 f2                	mov    %esi,%edx
  8023ae:	f7 f7                	div    %edi
  8023b0:	89 d0                	mov    %edx,%eax
  8023b2:	31 d2                	xor    %edx,%edx
  8023b4:	83 c4 1c             	add    $0x1c,%esp
  8023b7:	5b                   	pop    %ebx
  8023b8:	5e                   	pop    %esi
  8023b9:	5f                   	pop    %edi
  8023ba:	5d                   	pop    %ebp
  8023bb:	c3                   	ret    
  8023bc:	39 f0                	cmp    %esi,%eax
  8023be:	0f 87 ac 00 00 00    	ja     802470 <__umoddi3+0xfc>
  8023c4:	0f bd e8             	bsr    %eax,%ebp
  8023c7:	83 f5 1f             	xor    $0x1f,%ebp
  8023ca:	0f 84 ac 00 00 00    	je     80247c <__umoddi3+0x108>
  8023d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8023d5:	29 ef                	sub    %ebp,%edi
  8023d7:	89 fe                	mov    %edi,%esi
  8023d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023dd:	89 e9                	mov    %ebp,%ecx
  8023df:	d3 e0                	shl    %cl,%eax
  8023e1:	89 d7                	mov    %edx,%edi
  8023e3:	89 f1                	mov    %esi,%ecx
  8023e5:	d3 ef                	shr    %cl,%edi
  8023e7:	09 c7                	or     %eax,%edi
  8023e9:	89 e9                	mov    %ebp,%ecx
  8023eb:	d3 e2                	shl    %cl,%edx
  8023ed:	89 14 24             	mov    %edx,(%esp)
  8023f0:	89 d8                	mov    %ebx,%eax
  8023f2:	d3 e0                	shl    %cl,%eax
  8023f4:	89 c2                	mov    %eax,%edx
  8023f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023fa:	d3 e0                	shl    %cl,%eax
  8023fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802400:	8b 44 24 08          	mov    0x8(%esp),%eax
  802404:	89 f1                	mov    %esi,%ecx
  802406:	d3 e8                	shr    %cl,%eax
  802408:	09 d0                	or     %edx,%eax
  80240a:	d3 eb                	shr    %cl,%ebx
  80240c:	89 da                	mov    %ebx,%edx
  80240e:	f7 f7                	div    %edi
  802410:	89 d3                	mov    %edx,%ebx
  802412:	f7 24 24             	mull   (%esp)
  802415:	89 c6                	mov    %eax,%esi
  802417:	89 d1                	mov    %edx,%ecx
  802419:	39 d3                	cmp    %edx,%ebx
  80241b:	0f 82 87 00 00 00    	jb     8024a8 <__umoddi3+0x134>
  802421:	0f 84 91 00 00 00    	je     8024b8 <__umoddi3+0x144>
  802427:	8b 54 24 04          	mov    0x4(%esp),%edx
  80242b:	29 f2                	sub    %esi,%edx
  80242d:	19 cb                	sbb    %ecx,%ebx
  80242f:	89 d8                	mov    %ebx,%eax
  802431:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802435:	d3 e0                	shl    %cl,%eax
  802437:	89 e9                	mov    %ebp,%ecx
  802439:	d3 ea                	shr    %cl,%edx
  80243b:	09 d0                	or     %edx,%eax
  80243d:	89 e9                	mov    %ebp,%ecx
  80243f:	d3 eb                	shr    %cl,%ebx
  802441:	89 da                	mov    %ebx,%edx
  802443:	83 c4 1c             	add    $0x1c,%esp
  802446:	5b                   	pop    %ebx
  802447:	5e                   	pop    %esi
  802448:	5f                   	pop    %edi
  802449:	5d                   	pop    %ebp
  80244a:	c3                   	ret    
  80244b:	90                   	nop
  80244c:	89 fd                	mov    %edi,%ebp
  80244e:	85 ff                	test   %edi,%edi
  802450:	75 0b                	jne    80245d <__umoddi3+0xe9>
  802452:	b8 01 00 00 00       	mov    $0x1,%eax
  802457:	31 d2                	xor    %edx,%edx
  802459:	f7 f7                	div    %edi
  80245b:	89 c5                	mov    %eax,%ebp
  80245d:	89 f0                	mov    %esi,%eax
  80245f:	31 d2                	xor    %edx,%edx
  802461:	f7 f5                	div    %ebp
  802463:	89 c8                	mov    %ecx,%eax
  802465:	f7 f5                	div    %ebp
  802467:	89 d0                	mov    %edx,%eax
  802469:	e9 44 ff ff ff       	jmp    8023b2 <__umoddi3+0x3e>
  80246e:	66 90                	xchg   %ax,%ax
  802470:	89 c8                	mov    %ecx,%eax
  802472:	89 f2                	mov    %esi,%edx
  802474:	83 c4 1c             	add    $0x1c,%esp
  802477:	5b                   	pop    %ebx
  802478:	5e                   	pop    %esi
  802479:	5f                   	pop    %edi
  80247a:	5d                   	pop    %ebp
  80247b:	c3                   	ret    
  80247c:	3b 04 24             	cmp    (%esp),%eax
  80247f:	72 06                	jb     802487 <__umoddi3+0x113>
  802481:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802485:	77 0f                	ja     802496 <__umoddi3+0x122>
  802487:	89 f2                	mov    %esi,%edx
  802489:	29 f9                	sub    %edi,%ecx
  80248b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80248f:	89 14 24             	mov    %edx,(%esp)
  802492:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802496:	8b 44 24 04          	mov    0x4(%esp),%eax
  80249a:	8b 14 24             	mov    (%esp),%edx
  80249d:	83 c4 1c             	add    $0x1c,%esp
  8024a0:	5b                   	pop    %ebx
  8024a1:	5e                   	pop    %esi
  8024a2:	5f                   	pop    %edi
  8024a3:	5d                   	pop    %ebp
  8024a4:	c3                   	ret    
  8024a5:	8d 76 00             	lea    0x0(%esi),%esi
  8024a8:	2b 04 24             	sub    (%esp),%eax
  8024ab:	19 fa                	sbb    %edi,%edx
  8024ad:	89 d1                	mov    %edx,%ecx
  8024af:	89 c6                	mov    %eax,%esi
  8024b1:	e9 71 ff ff ff       	jmp    802427 <__umoddi3+0xb3>
  8024b6:	66 90                	xchg   %ax,%ax
  8024b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8024bc:	72 ea                	jb     8024a8 <__umoddi3+0x134>
  8024be:	89 d9                	mov    %ebx,%ecx
  8024c0:	e9 62 ff ff ff       	jmp    802427 <__umoddi3+0xb3>
