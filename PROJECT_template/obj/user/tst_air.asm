
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 15 0b 00 00       	call   800b4b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec fc 01 00 00    	sub    $0x1fc,%esp
	int envID = sys_getenvid();
  800044:	e8 64 22 00 00       	call   8022ad <sys_getenvid>
  800049:	89 45 bc             	mov    %eax,-0x44(%ebp)

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************

	int numOfCustomers = 15;
  80004c:	c7 45 b8 0f 00 00 00 	movl   $0xf,-0x48(%ebp)
	int flight1Customers = 3;
  800053:	c7 45 b4 03 00 00 00 	movl   $0x3,-0x4c(%ebp)
	int flight2Customers = 8;
  80005a:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%ebp)
	int flight3Customers = 4;
  800061:	c7 45 ac 04 00 00 00 	movl   $0x4,-0x54(%ebp)

	int flight1NumOfTickets = 8;
  800068:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%ebp)
	int flight2NumOfTickets = 15;
  80006f:	c7 45 a4 0f 00 00 00 	movl   $0xf,-0x5c(%ebp)

	char _customers[] = "customers";
  800076:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  80007c:	bb 76 2e 80 00       	mov    $0x802e76,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800094:	bb 80 2e 80 00       	mov    $0x802e80,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  8000ac:	bb 8c 2e 80 00       	mov    $0x802e8c,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8000c4:	bb 9b 2e 80 00       	mov    $0x802e9b,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8000dc:	bb aa 2e 80 00       	mov    $0x802eaa,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8000f4:	bb bf 2e 80 00       	mov    $0x802ebf,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  80010c:	bb d4 2e 80 00       	mov    $0x802ed4,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800124:	bb e5 2e 80 00       	mov    $0x802ee5,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80013c:	bb f6 2e 80 00       	mov    $0x802ef6,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800154:	bb 07 2f 80 00       	mov    $0x802f07,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80016c:	bb 10 2f 80 00       	mov    $0x802f10,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800184:	bb 1a 2f 80 00       	mov    $0x802f1a,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  80019c:	bb 25 2f 80 00       	mov    $0x802f25,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8001b4:	bb 31 2f 80 00       	mov    $0x802f31,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8001cc:	bb 3b 2f 80 00       	mov    $0x802f3b,%ebx
  8001d1:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001d6:	89 c7                	mov    %eax,%edi
  8001d8:	89 de                	mov    %ebx,%esi
  8001da:	89 d1                	mov    %edx,%ecx
  8001dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001de:	c7 85 9f fe ff ff 63 	movl   $0x72656c63,-0x161(%ebp)
  8001e5:	6c 65 72 
  8001e8:	66 c7 85 a3 fe ff ff 	movw   $0x6b,-0x15d(%ebp)
  8001ef:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001f1:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8001f7:	bb 45 2f 80 00       	mov    $0x802f45,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  80020f:	bb 53 2f 80 00       	mov    $0x802f53,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800227:	bb 62 2f 80 00       	mov    $0x802f62,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80023f:	bb 69 2f 80 00       	mov    $0x802f69,%ebx
  800244:	ba 07 00 00 00       	mov    $0x7,%edx
  800249:	89 c7                	mov    %eax,%edi
  80024b:	89 de                	mov    %ebx,%esi
  80024d:	89 d1                	mov    %edx,%ecx
  80024f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*numOfCustomers, 1);
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	c1 e0 03             	shl    $0x3,%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	6a 01                	push   $0x1
  80025c:	50                   	push   %eax
  80025d:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	e8 eb 1e 00 00       	call   802154 <smalloc>
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
  80026f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for(;f1<flight1Customers; ++f1)
  800276:	eb 2e                	jmp    8002a6 <_main+0x26e>
		{
			custs[f1].booked = 0;
  800278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800282:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800285:	01 d0                	add    %edx,%eax
  800287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f1].flightType = 1;
  80028e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800291:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800298:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  8002a3:	ff 45 e4             	incl   -0x1c(%ebp)
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  8002ac:	7c ca                	jl     800278 <_main+0x240>
		{
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
  8002ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  8002b4:	eb 2e                	jmp    8002e4 <_main+0x2ac>
		{
			custs[f2].booked = 0;
  8002b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f2].flightType = 2;
  8002cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  8002e1:	ff 45 e0             	incl   -0x20(%ebp)
  8002e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002ef:	7f c5                	jg     8002b6 <_main+0x27e>
		{
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
  8002f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  8002f7:	eb 2e                	jmp    800327 <_main+0x2ef>
		{
			custs[f3].booked = 0;
  8002f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800303:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f3].flightType = 3;
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  800324:	ff 45 dc             	incl   -0x24(%ebp)
  800327:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80032a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	7f c5                	jg     8002f9 <_main+0x2c1>
			custs[f3].booked = 0;
			custs[f3].flightType = 3;
		}
	}

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	6a 01                	push   $0x1
  800339:	6a 04                	push   $0x4
  80033b:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800341:	50                   	push   %eax
  800342:	e8 0d 1e 00 00       	call   802154 <smalloc>
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	89 45 9c             	mov    %eax,-0x64(%ebp)
	*custCounter = 0;
  80034d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	6a 01                	push   $0x1
  80035b:	6a 04                	push   $0x4
  80035d:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  800363:	50                   	push   %eax
  800364:	e8 eb 1d 00 00       	call   802154 <smalloc>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	89 45 98             	mov    %eax,-0x68(%ebp)
	*flight1Counter = flight1NumOfTickets;
  80036f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800372:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800375:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	6a 01                	push   $0x1
  80037c:	6a 04                	push   $0x4
  80037e:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800384:	50                   	push   %eax
  800385:	e8 ca 1d 00 00       	call   802154 <smalloc>
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	89 45 94             	mov    %eax,-0x6c(%ebp)
	*flight2Counter = flight2NumOfTickets;
  800390:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800393:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800396:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	6a 01                	push   $0x1
  80039d:	6a 04                	push   $0x4
  80039f:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	e8 a9 1d 00 00       	call   802154 <smalloc>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	89 45 90             	mov    %eax,-0x70(%ebp)
	*flight1BookedCounter = 0;
  8003b1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	6a 01                	push   $0x1
  8003bf:	6a 04                	push   $0x4
  8003c1:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 87 1d 00 00       	call   802154 <smalloc>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 8c             	mov    %eax,-0x74(%ebp)
	*flight2BookedCounter = 0;
  8003d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  8003dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003df:	c1 e0 02             	shl    $0x2,%eax
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	6a 01                	push   $0x1
  8003e7:	50                   	push   %eax
  8003e8:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  8003ee:	50                   	push   %eax
  8003ef:	e8 60 1d 00 00       	call   802154 <smalloc>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 45 88             	mov    %eax,-0x78(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  8003fa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fd:	c1 e0 02             	shl    $0x2,%eax
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	6a 01                	push   $0x1
  800405:	50                   	push   %eax
  800406:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	e8 42 1d 00 00       	call   802154 <smalloc>
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	89 45 84             	mov    %eax,-0x7c(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*numOfCustomers, 1);
  800418:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80041b:	c1 e0 02             	shl    $0x2,%eax
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	6a 01                	push   $0x1
  800423:	50                   	push   %eax
  800424:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80042a:	50                   	push   %eax
  80042b:	e8 24 1d 00 00       	call   802154 <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 0b 1d 00 00       	call   802154 <smalloc>
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*queue_in = 0;
  800452:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	6a 01                	push   $0x1
  800463:	6a 04                	push   $0x4
  800465:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80046b:	50                   	push   %eax
  80046c:	e8 e3 1c 00 00       	call   802154 <smalloc>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*queue_out = 0;
  80047a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************
	sys_createSemaphore(_flight1CS, 1);
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	6a 01                	push   $0x1
  80048b:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  800491:	50                   	push   %eax
  800492:	e8 3e 20 00 00       	call   8024d5 <sys_createSemaphore>
  800497:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_flight2CS, 1);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	6a 01                	push   $0x1
  80049f:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8004a5:	50                   	push   %eax
  8004a6:	e8 2a 20 00 00       	call   8024d5 <sys_createSemaphore>
  8004ab:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custCounterCS, 1);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	6a 01                	push   $0x1
  8004b3:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8004b9:	50                   	push   %eax
  8004ba:	e8 16 20 00 00       	call   8024d5 <sys_createSemaphore>
  8004bf:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_custQueueCS, 1);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 02 20 00 00       	call   8024d5 <sys_createSemaphore>
  8004d3:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_clerk, 3);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	6a 03                	push   $0x3
  8004db:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	e8 ee 1f 00 00       	call   8024d5 <sys_createSemaphore>
  8004e7:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_cust_ready, 0);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	6a 00                	push   $0x0
  8004ef:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 da 1f 00 00       	call   8024d5 <sys_createSemaphore>
  8004fb:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custTerminated, 0);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	6a 00                	push   $0x0
  800503:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800509:	50                   	push   %eax
  80050a:	e8 c6 1f 00 00       	call   8024d5 <sys_createSemaphore>
  80050f:	83 c4 10             	add    $0x10,%esp

	int s=0;
  800512:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800519:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800520:	eb 78                	jmp    80059a <_main+0x562>
	{
		char prefix[30]="cust_finished";
  800522:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  800528:	bb 70 2f 80 00       	mov    $0x802f70,%ebx
  80052d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800532:	89 c7                	mov    %eax,%edi
  800534:	89 de                	mov    %ebx,%esi
  800536:	89 d1                	mov    %edx,%ecx
  800538:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80053a:	8d 95 64 fe ff ff    	lea    -0x19c(%ebp),%edx
  800540:	b9 04 00 00 00       	mov    $0x4,%ecx
  800545:	b8 00 00 00 00       	mov    $0x0,%eax
  80054a:	89 d7                	mov    %edx,%edi
  80054c:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800557:	50                   	push   %eax
  800558:	ff 75 d8             	pushl  -0x28(%ebp)
  80055b:	e8 fa 14 00 00       	call   801a5a <ltostr>
  800560:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  800563:	83 ec 04             	sub    $0x4,%esp
  800566:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80056c:	50                   	push   %eax
  80056d:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800573:	50                   	push   %eax
  800574:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	e8 d2 15 00 00       	call   801b52 <strcconcat>
  800580:	83 c4 10             	add    $0x10,%esp
		sys_createSemaphore(sname, 0);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	6a 00                	push   $0x0
  800588:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80058e:	50                   	push   %eax
  80058f:	e8 41 1f 00 00       	call   8024d5 <sys_createSemaphore>
  800594:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_cust_ready, 0);

	sys_createSemaphore(_custTerminated, 0);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  800597:	ff 45 d8             	incl   -0x28(%ebp)
  80059a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80059d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8005a0:	7c 80                	jl     800522 <_main+0x4ea>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//3 clerks
	uint32 envId;
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8005a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8005a7:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8005ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8005b2:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  8005b8:	89 c1                	mov    %eax,%ecx
  8005ba:	a1 20 40 80 00       	mov    0x804020,%eax
  8005bf:	8b 40 74             	mov    0x74(%eax),%eax
  8005c2:	52                   	push   %edx
  8005c3:	51                   	push   %ecx
  8005c4:	50                   	push   %eax
  8005c5:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  8005cb:	50                   	push   %eax
  8005cc:	e8 15 20 00 00       	call   8025e6 <sys_create_env>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  8005da:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 1b 20 00 00       	call   802604 <sys_run_env>
  8005e9:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8005ec:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f1:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8005f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8005fc:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  800602:	89 c1                	mov    %eax,%ecx
  800604:	a1 20 40 80 00       	mov    0x804020,%eax
  800609:	8b 40 74             	mov    0x74(%eax),%eax
  80060c:	52                   	push   %edx
  80060d:	51                   	push   %ecx
  80060e:	50                   	push   %eax
  80060f:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800615:	50                   	push   %eax
  800616:	e8 cb 1f 00 00       	call   8025e6 <sys_create_env>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  800624:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80062a:	83 ec 0c             	sub    $0xc,%esp
  80062d:	50                   	push   %eax
  80062e:	e8 d1 1f 00 00       	call   802604 <sys_run_env>
  800633:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800636:	a1 20 40 80 00       	mov    0x804020,%eax
  80063b:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800641:	a1 20 40 80 00       	mov    0x804020,%eax
  800646:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	a1 20 40 80 00       	mov    0x804020,%eax
  800653:	8b 40 74             	mov    0x74(%eax),%eax
  800656:	52                   	push   %edx
  800657:	51                   	push   %ecx
  800658:	50                   	push   %eax
  800659:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  80065f:	50                   	push   %eax
  800660:	e8 81 1f 00 00       	call   8025e6 <sys_create_env>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  80066e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800674:	83 ec 0c             	sub    $0xc,%esp
  800677:	50                   	push   %eax
  800678:	e8 87 1f 00 00       	call   802604 <sys_run_env>
  80067d:	83 c4 10             	add    $0x10,%esp

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800680:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800687:	eb 6d                	jmp    8006f6 <_main+0x6be>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800689:	a1 20 40 80 00       	mov    0x804020,%eax
  80068e:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800694:	a1 20 40 80 00       	mov    0x804020,%eax
  800699:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	a1 20 40 80 00       	mov    0x804020,%eax
  8006a6:	8b 40 74             	mov    0x74(%eax),%eax
  8006a9:	52                   	push   %edx
  8006aa:	51                   	push   %ecx
  8006ab:	50                   	push   %eax
  8006ac:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  8006b2:	50                   	push   %eax
  8006b3:	e8 2e 1f 00 00       	call   8025e6 <sys_create_env>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  8006c1:	83 bd 74 ff ff ff ef 	cmpl   $0xffffffef,-0x8c(%ebp)
  8006c8:	75 17                	jne    8006e1 <_main+0x6a9>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	68 a0 2b 80 00       	push   $0x802ba0
  8006d2:	68 95 00 00 00       	push   $0x95
  8006d7:	68 e6 2b 80 00       	push   $0x802be6
  8006dc:	e8 af 05 00 00       	call   800c90 <_panic>

		sys_run_env(envId);
  8006e1:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 14 1f 00 00       	call   802604 <sys_run_env>
  8006f0:	83 c4 10             	add    $0x10,%esp
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
	sys_run_env(envId);

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  8006f3:	ff 45 d4             	incl   -0x2c(%ebp)
  8006f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8006fc:	7c 8b                	jl     800689 <_main+0x651>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8006fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800705:	eb 18                	jmp    80071f <_main+0x6e7>
	{
		sys_waitSemaphore(envID, _custTerminated);
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800710:	50                   	push   %eax
  800711:	ff 75 bc             	pushl  -0x44(%ebp)
  800714:	e8 f5 1d 00 00       	call   80250e <sys_waitSemaphore>
  800719:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  80071c:	ff 45 d4             	incl   -0x2c(%ebp)
  80071f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800722:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800725:	7c e0                	jl     800707 <_main+0x6cf>
	{
		sys_waitSemaphore(envID, _custTerminated);
	}

	env_sleep(1500);
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	68 dc 05 00 00       	push   $0x5dc
  80072f:	e8 4e 21 00 00       	call   802882 <env_sleep>
  800734:	83 c4 10             	add    $0x10,%esp

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800737:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80073e:	eb 45                	jmp    800785 <_main+0x74d>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  800740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800758:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80075b:	01 d0                	add    %edx,%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800762:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800769:	8b 45 88             	mov    -0x78(%ebp),%eax
  80076c:	01 c8                	add    %ecx,%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 ec 04             	sub    $0x4,%esp
  800773:	52                   	push   %edx
  800774:	50                   	push   %eax
  800775:	68 f8 2b 80 00       	push   $0x802bf8
  80077a:	e8 b3 07 00 00       	call   800f32 <cprintf>
  80077f:	83 c4 10             	add    $0x10,%esp

	env_sleep(1500);

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800782:	ff 45 d0             	incl   -0x30(%ebp)
  800785:	8b 45 90             	mov    -0x70(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80078d:	7f b1                	jg     800740 <_main+0x708>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  80078f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800796:	eb 45                	jmp    8007dd <_main+0x7a5>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800798:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80079b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007a2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007a5:	01 d0                	add    %edx,%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007b0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007b3:	01 d0                	add    %edx,%eax
  8007b5:	8b 10                	mov    (%eax),%edx
  8007b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007c1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007c4:	01 c8                	add    %ecx,%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 ec 04             	sub    $0x4,%esp
  8007cb:	52                   	push   %edx
  8007cc:	50                   	push   %eax
  8007cd:	68 28 2c 80 00       	push   $0x802c28
  8007d2:	e8 5b 07 00 00       	call   800f32 <cprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  8007da:	ff 45 d0             	incl   -0x30(%ebp)
  8007dd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8007e5:	7f b1                	jg     800798 <_main+0x760>
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
  8007e7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		for(;f1<flight1Customers; ++f1)
  8007ee:	eb 33                	jmp    800823 <_main+0x7eb>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f1) != 1)
  8007f0:	83 ec 04             	sub    $0x4,%esp
  8007f3:	ff 75 cc             	pushl  -0x34(%ebp)
  8007f6:	ff 75 a8             	pushl  -0x58(%ebp)
  8007f9:	ff 75 88             	pushl  -0x78(%ebp)
  8007fc:	e8 05 03 00 00       	call   800b06 <find>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	83 f8 01             	cmp    $0x1,%eax
  800807:	74 17                	je     800820 <_main+0x7e8>
			{
				panic("Error, wrong booking for user %d\n", f1);
  800809:	ff 75 cc             	pushl  -0x34(%ebp)
  80080c:	68 58 2c 80 00       	push   $0x802c58
  800811:	68 b5 00 00 00       	push   $0xb5
  800816:	68 e6 2b 80 00       	push   $0x802be6
  80081b:	e8 70 04 00 00       	call   800c90 <_panic>
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  800820:	ff 45 cc             	incl   -0x34(%ebp)
  800823:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800826:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  800829:	7c c5                	jl     8007f0 <_main+0x7b8>
			{
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
  80082b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80082e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  800831:	eb 33                	jmp    800866 <_main+0x82e>
		{
			if(find(flight2BookedArr, flight2NumOfTickets, f2) != 1)
  800833:	83 ec 04             	sub    $0x4,%esp
  800836:	ff 75 c8             	pushl  -0x38(%ebp)
  800839:	ff 75 a4             	pushl  -0x5c(%ebp)
  80083c:	ff 75 84             	pushl  -0x7c(%ebp)
  80083f:	e8 c2 02 00 00       	call   800b06 <find>
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	83 f8 01             	cmp    $0x1,%eax
  80084a:	74 17                	je     800863 <_main+0x82b>
			{
				panic("Error, wrong booking for user %d\n", f2);
  80084c:	ff 75 c8             	pushl  -0x38(%ebp)
  80084f:	68 58 2c 80 00       	push   $0x802c58
  800854:	68 be 00 00 00       	push   $0xbe
  800859:	68 e6 2b 80 00       	push   $0x802be6
  80085e:	e8 2d 04 00 00       	call   800c90 <_panic>
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  800863:	ff 45 c8             	incl   -0x38(%ebp)
  800866:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800869:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80086c:	01 d0                	add    %edx,%eax
  80086e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800871:	7f c0                	jg     800833 <_main+0x7fb>
			{
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
  800873:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800876:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  800879:	eb 4c                	jmp    8008c7 <_main+0x88f>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f3) != 1 || find(flight2BookedArr, flight2NumOfTickets, f3) != 1)
  80087b:	83 ec 04             	sub    $0x4,%esp
  80087e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800881:	ff 75 a8             	pushl  -0x58(%ebp)
  800884:	ff 75 88             	pushl  -0x78(%ebp)
  800887:	e8 7a 02 00 00       	call   800b06 <find>
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	83 f8 01             	cmp    $0x1,%eax
  800892:	75 19                	jne    8008ad <_main+0x875>
  800894:	83 ec 04             	sub    $0x4,%esp
  800897:	ff 75 c4             	pushl  -0x3c(%ebp)
  80089a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80089d:	ff 75 84             	pushl  -0x7c(%ebp)
  8008a0:	e8 61 02 00 00       	call   800b06 <find>
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	83 f8 01             	cmp    $0x1,%eax
  8008ab:	74 17                	je     8008c4 <_main+0x88c>
			{
				panic("Error, wrong booking for user %d\n", f3);
  8008ad:	ff 75 c4             	pushl  -0x3c(%ebp)
  8008b0:	68 58 2c 80 00       	push   $0x802c58
  8008b5:	68 c7 00 00 00       	push   $0xc7
  8008ba:	68 e6 2b 80 00       	push   $0x802be6
  8008bf:	e8 cc 03 00 00       	call   800c90 <_panic>
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  8008c4:	ff 45 c4             	incl   -0x3c(%ebp)
  8008c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8008ca:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8008cd:	01 d0                	add    %edx,%eax
  8008cf:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8008d2:	7f a7                	jg     80087b <_main+0x843>
			{
				panic("Error, wrong booking for user %d\n", f3);
			}
		}

		assert(sys_getSemaphoreValue(envID, _flight1CS) == 1);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8008dd:	50                   	push   %eax
  8008de:	ff 75 bc             	pushl  -0x44(%ebp)
  8008e1:	e8 0b 1c 00 00       	call   8024f1 <sys_getSemaphoreValue>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	83 f8 01             	cmp    $0x1,%eax
  8008ec:	74 19                	je     800907 <_main+0x8cf>
  8008ee:	68 7c 2c 80 00       	push   $0x802c7c
  8008f3:	68 aa 2c 80 00       	push   $0x802caa
  8008f8:	68 cb 00 00 00       	push   $0xcb
  8008fd:	68 e6 2b 80 00       	push   $0x802be6
  800902:	e8 89 03 00 00       	call   800c90 <_panic>
		assert(sys_getSemaphoreValue(envID, _flight2CS) == 1);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	ff 75 bc             	pushl  -0x44(%ebp)
  800914:	e8 d8 1b 00 00       	call   8024f1 <sys_getSemaphoreValue>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	83 f8 01             	cmp    $0x1,%eax
  80091f:	74 19                	je     80093a <_main+0x902>
  800921:	68 c0 2c 80 00       	push   $0x802cc0
  800926:	68 aa 2c 80 00       	push   $0x802caa
  80092b:	68 cc 00 00 00       	push   $0xcc
  800930:	68 e6 2b 80 00       	push   $0x802be6
  800935:	e8 56 03 00 00       	call   800c90 <_panic>

		assert(sys_getSemaphoreValue(envID, _custCounterCS) ==  1);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	ff 75 bc             	pushl  -0x44(%ebp)
  800947:	e8 a5 1b 00 00       	call   8024f1 <sys_getSemaphoreValue>
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	83 f8 01             	cmp    $0x1,%eax
  800952:	74 19                	je     80096d <_main+0x935>
  800954:	68 f0 2c 80 00       	push   $0x802cf0
  800959:	68 aa 2c 80 00       	push   $0x802caa
  80095e:	68 ce 00 00 00       	push   $0xce
  800963:	68 e6 2b 80 00       	push   $0x802be6
  800968:	e8 23 03 00 00       	call   800c90 <_panic>
		assert(sys_getSemaphoreValue(envID, _custQueueCS) ==  1);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  800976:	50                   	push   %eax
  800977:	ff 75 bc             	pushl  -0x44(%ebp)
  80097a:	e8 72 1b 00 00       	call   8024f1 <sys_getSemaphoreValue>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	83 f8 01             	cmp    $0x1,%eax
  800985:	74 19                	je     8009a0 <_main+0x968>
  800987:	68 24 2d 80 00       	push   $0x802d24
  80098c:	68 aa 2c 80 00       	push   $0x802caa
  800991:	68 cf 00 00 00       	push   $0xcf
  800996:	68 e6 2b 80 00       	push   $0x802be6
  80099b:	e8 f0 02 00 00       	call   800c90 <_panic>

		assert(sys_getSemaphoreValue(envID, _clerk) == 3);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	ff 75 bc             	pushl  -0x44(%ebp)
  8009ad:	e8 3f 1b 00 00       	call   8024f1 <sys_getSemaphoreValue>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	83 f8 03             	cmp    $0x3,%eax
  8009b8:	74 19                	je     8009d3 <_main+0x99b>
  8009ba:	68 54 2d 80 00       	push   $0x802d54
  8009bf:	68 aa 2c 80 00       	push   $0x802caa
  8009c4:	68 d1 00 00 00       	push   $0xd1
  8009c9:	68 e6 2b 80 00       	push   $0x802be6
  8009ce:	e8 bd 02 00 00       	call   800c90 <_panic>

		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8009e0:	e8 0c 1b 00 00       	call   8024f1 <sys_getSemaphoreValue>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8009eb:	74 19                	je     800a06 <_main+0x9ce>
  8009ed:	68 80 2d 80 00       	push   $0x802d80
  8009f2:	68 aa 2c 80 00       	push   $0x802caa
  8009f7:	68 d3 00 00 00       	push   $0xd3
  8009fc:	68 e6 2b 80 00       	push   $0x802be6
  800a01:	e8 8a 02 00 00       	call   800c90 <_panic>

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	ff 75 bc             	pushl  -0x44(%ebp)
  800a13:	e8 d9 1a 00 00       	call   8024f1 <sys_getSemaphoreValue>
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	74 19                	je     800a38 <_main+0xa00>
  800a1f:	68 b0 2d 80 00       	push   $0x802db0
  800a24:	68 aa 2c 80 00       	push   $0x802caa
  800a29:	68 d5 00 00 00       	push   $0xd5
  800a2e:	68 e6 2b 80 00       	push   $0x802be6
  800a33:	e8 58 02 00 00       	call   800c90 <_panic>

		int s=0;
  800a38:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800a3f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800a46:	e9 96 00 00 00       	jmp    800ae1 <_main+0xaa9>
		{
			char prefix[30]="cust_finished";
  800a4b:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800a51:	bb 70 2f 80 00       	mov    $0x802f70,%ebx
  800a56:	ba 0e 00 00 00       	mov    $0xe,%edx
  800a5b:	89 c7                	mov    %eax,%edi
  800a5d:	89 de                	mov    %ebx,%esi
  800a5f:	89 d1                	mov    %edx,%ecx
  800a61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800a63:	8d 95 41 fe ff ff    	lea    -0x1bf(%ebp),%edx
  800a69:	b9 04 00 00 00       	mov    $0x4,%ecx
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a73:	89 d7                	mov    %edx,%edi
  800a75:	f3 ab                	rep stos %eax,%es:(%edi)
			char id[5]; char cust_finishedSemaphoreName[50];
			ltostr(s, id);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a80:	50                   	push   %eax
  800a81:	ff 75 c0             	pushl  -0x40(%ebp)
  800a84:	e8 d1 0f 00 00       	call   801a5a <ltostr>
  800a89:	83 c4 10             	add    $0x10,%esp
			strcconcat(prefix, id, cust_finishedSemaphoreName);
  800a8c:	83 ec 04             	sub    $0x4,%esp
  800a8f:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800a95:	50                   	push   %eax
  800a96:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a9c:	50                   	push   %eax
  800a9d:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800aa3:	50                   	push   %eax
  800aa4:	e8 a9 10 00 00       	call   801b52 <strcconcat>
  800aa9:	83 c4 10             	add    $0x10,%esp
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 bc             	pushl  -0x44(%ebp)
  800ab9:	e8 33 1a 00 00       	call   8024f1 <sys_getSemaphoreValue>
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	74 19                	je     800ade <_main+0xaa6>
  800ac5:	68 e4 2d 80 00       	push   $0x802de4
  800aca:	68 aa 2c 80 00       	push   $0x802caa
  800acf:	68 de 00 00 00       	push   $0xde
  800ad4:	68 e6 2b 80 00       	push   $0x802be6
  800ad9:	e8 b2 01 00 00       	call   800c90 <_panic>
		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800ade:	ff 45 c0             	incl   -0x40(%ebp)
  800ae1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ae4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800ae7:	0f 8c 5e ff ff ff    	jl     800a4b <_main+0xa13>
			ltostr(s, id);
			strcconcat(prefix, id, cust_finishedSemaphoreName);
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
		}

		cprintf("Congratulations, All reservations are successfully done... have a nice flight :)\n");
  800aed:	83 ec 0c             	sub    $0xc,%esp
  800af0:	68 24 2e 80 00       	push   $0x802e24
  800af5:	e8 38 04 00 00       	call   800f32 <cprintf>
  800afa:	83 c4 10             	add    $0x10,%esp
	}

}
  800afd:	90                   	nop
  800afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <find>:


int find(int* arr, int size, int val)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800b0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800b13:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800b1a:	eb 22                	jmp    800b3e <find+0x38>
	{
		if(arr[i] == val)
  800b1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	01 d0                	add    %edx,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b30:	75 09                	jne    800b3b <find+0x35>
		{
			result = 1;
  800b32:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800b39:	eb 0b                	jmp    800b46 <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800b3b:	ff 45 f8             	incl   -0x8(%ebp)
  800b3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b41:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b44:	7c d6                	jl     800b1c <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b51:	e8 70 17 00 00       	call   8022c6 <sys_getenvindex>
  800b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5c:	89 d0                	mov    %edx,%eax
  800b5e:	c1 e0 03             	shl    $0x3,%eax
  800b61:	01 d0                	add    %edx,%eax
  800b63:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800b6a:	01 c8                	add    %ecx,%eax
  800b6c:	01 c0                	add    %eax,%eax
  800b6e:	01 d0                	add    %edx,%eax
  800b70:	01 c0                	add    %eax,%eax
  800b72:	01 d0                	add    %edx,%eax
  800b74:	89 c2                	mov    %eax,%edx
  800b76:	c1 e2 05             	shl    $0x5,%edx
  800b79:	29 c2                	sub    %eax,%edx
  800b7b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800b82:	89 c2                	mov    %eax,%edx
  800b84:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800b8a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b8f:	a1 20 40 80 00       	mov    0x804020,%eax
  800b94:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800b9a:	84 c0                	test   %al,%al
  800b9c:	74 0f                	je     800bad <libmain+0x62>
		binaryname = myEnv->prog_name;
  800b9e:	a1 20 40 80 00       	mov    0x804020,%eax
  800ba3:	05 40 3c 01 00       	add    $0x13c40,%eax
  800ba8:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bb1:	7e 0a                	jle    800bbd <libmain+0x72>
		binaryname = argv[0];
  800bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 0c             	pushl  0xc(%ebp)
  800bc3:	ff 75 08             	pushl  0x8(%ebp)
  800bc6:	e8 6d f4 ff ff       	call   800038 <_main>
  800bcb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bce:	e8 8e 18 00 00       	call   802461 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800bd3:	83 ec 0c             	sub    $0xc,%esp
  800bd6:	68 a8 2f 80 00       	push   $0x802fa8
  800bdb:	e8 52 03 00 00       	call   800f32 <cprintf>
  800be0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800be3:	a1 20 40 80 00       	mov    0x804020,%eax
  800be8:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800bee:	a1 20 40 80 00       	mov    0x804020,%eax
  800bf3:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800bf9:	83 ec 04             	sub    $0x4,%esp
  800bfc:	52                   	push   %edx
  800bfd:	50                   	push   %eax
  800bfe:	68 d0 2f 80 00       	push   $0x802fd0
  800c03:	e8 2a 03 00 00       	call   800f32 <cprintf>
  800c08:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800c0b:	a1 20 40 80 00       	mov    0x804020,%eax
  800c10:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800c16:	a1 20 40 80 00       	mov    0x804020,%eax
  800c1b:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800c21:	83 ec 04             	sub    $0x4,%esp
  800c24:	52                   	push   %edx
  800c25:	50                   	push   %eax
  800c26:	68 f8 2f 80 00       	push   $0x802ff8
  800c2b:	e8 02 03 00 00       	call   800f32 <cprintf>
  800c30:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c33:	a1 20 40 80 00       	mov    0x804020,%eax
  800c38:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800c3e:	83 ec 08             	sub    $0x8,%esp
  800c41:	50                   	push   %eax
  800c42:	68 39 30 80 00       	push   $0x803039
  800c47:	e8 e6 02 00 00       	call   800f32 <cprintf>
  800c4c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c4f:	83 ec 0c             	sub    $0xc,%esp
  800c52:	68 a8 2f 80 00       	push   $0x802fa8
  800c57:	e8 d6 02 00 00       	call   800f32 <cprintf>
  800c5c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c5f:	e8 17 18 00 00       	call   80247b <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c64:	e8 19 00 00 00       	call   800c82 <exit>
}
  800c69:	90                   	nop
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    

00800c6c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800c72:	83 ec 0c             	sub    $0xc,%esp
  800c75:	6a 00                	push   $0x0
  800c77:	e8 16 16 00 00       	call   802292 <sys_env_destroy>
  800c7c:	83 c4 10             	add    $0x10,%esp
}
  800c7f:	90                   	nop
  800c80:	c9                   	leave  
  800c81:	c3                   	ret    

00800c82 <exit>:

void
exit(void)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800c88:	e8 6b 16 00 00       	call   8022f8 <sys_env_exit>
}
  800c8d:	90                   	nop
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    

00800c90 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c96:	8d 45 10             	lea    0x10(%ebp),%eax
  800c99:	83 c0 04             	add    $0x4,%eax
  800c9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c9f:	a1 18 41 80 00       	mov    0x804118,%eax
  800ca4:	85 c0                	test   %eax,%eax
  800ca6:	74 16                	je     800cbe <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ca8:	a1 18 41 80 00       	mov    0x804118,%eax
  800cad:	83 ec 08             	sub    $0x8,%esp
  800cb0:	50                   	push   %eax
  800cb1:	68 50 30 80 00       	push   $0x803050
  800cb6:	e8 77 02 00 00       	call   800f32 <cprintf>
  800cbb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cbe:	a1 00 40 80 00       	mov    0x804000,%eax
  800cc3:	ff 75 0c             	pushl  0xc(%ebp)
  800cc6:	ff 75 08             	pushl  0x8(%ebp)
  800cc9:	50                   	push   %eax
  800cca:	68 55 30 80 00       	push   $0x803055
  800ccf:	e8 5e 02 00 00       	call   800f32 <cprintf>
  800cd4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cda:	83 ec 08             	sub    $0x8,%esp
  800cdd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce0:	50                   	push   %eax
  800ce1:	e8 e1 01 00 00       	call   800ec7 <vcprintf>
  800ce6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ce9:	83 ec 08             	sub    $0x8,%esp
  800cec:	6a 00                	push   $0x0
  800cee:	68 71 30 80 00       	push   $0x803071
  800cf3:	e8 cf 01 00 00       	call   800ec7 <vcprintf>
  800cf8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800cfb:	e8 82 ff ff ff       	call   800c82 <exit>

	// should not return here
	while (1) ;
  800d00:	eb fe                	jmp    800d00 <_panic+0x70>

00800d02 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800d08:	a1 20 40 80 00       	mov    0x804020,%eax
  800d0d:	8b 50 74             	mov    0x74(%eax),%edx
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	39 c2                	cmp    %eax,%edx
  800d15:	74 14                	je     800d2b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d17:	83 ec 04             	sub    $0x4,%esp
  800d1a:	68 74 30 80 00       	push   $0x803074
  800d1f:	6a 26                	push   $0x26
  800d21:	68 c0 30 80 00       	push   $0x8030c0
  800d26:	e8 65 ff ff ff       	call   800c90 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d32:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d39:	e9 b6 00 00 00       	jmp    800df4 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d41:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	01 d0                	add    %edx,%eax
  800d4d:	8b 00                	mov    (%eax),%eax
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	75 08                	jne    800d5b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d53:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d56:	e9 96 00 00 00       	jmp    800df1 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800d5b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d62:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d69:	eb 5d                	jmp    800dc8 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d6b:	a1 20 40 80 00       	mov    0x804020,%eax
  800d70:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800d76:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d79:	c1 e2 04             	shl    $0x4,%edx
  800d7c:	01 d0                	add    %edx,%eax
  800d7e:	8a 40 04             	mov    0x4(%eax),%al
  800d81:	84 c0                	test   %al,%al
  800d83:	75 40                	jne    800dc5 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d85:	a1 20 40 80 00       	mov    0x804020,%eax
  800d8a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800d90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d93:	c1 e2 04             	shl    $0x4,%edx
  800d96:	01 d0                	add    %edx,%eax
  800d98:	8b 00                	mov    (%eax),%eax
  800d9a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800da0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800da5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800daa:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	01 c8                	add    %ecx,%eax
  800db6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800db8:	39 c2                	cmp    %eax,%edx
  800dba:	75 09                	jne    800dc5 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800dbc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800dc3:	eb 12                	jmp    800dd7 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc5:	ff 45 e8             	incl   -0x18(%ebp)
  800dc8:	a1 20 40 80 00       	mov    0x804020,%eax
  800dcd:	8b 50 74             	mov    0x74(%eax),%edx
  800dd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dd3:	39 c2                	cmp    %eax,%edx
  800dd5:	77 94                	ja     800d6b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dd7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ddb:	75 14                	jne    800df1 <CheckWSWithoutLastIndex+0xef>
			panic(
  800ddd:	83 ec 04             	sub    $0x4,%esp
  800de0:	68 cc 30 80 00       	push   $0x8030cc
  800de5:	6a 3a                	push   $0x3a
  800de7:	68 c0 30 80 00       	push   $0x8030c0
  800dec:	e8 9f fe ff ff       	call   800c90 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800df1:	ff 45 f0             	incl   -0x10(%ebp)
  800df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dfa:	0f 8c 3e ff ff ff    	jl     800d3e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e07:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e0e:	eb 20                	jmp    800e30 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e10:	a1 20 40 80 00       	mov    0x804020,%eax
  800e15:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800e1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e1e:	c1 e2 04             	shl    $0x4,%edx
  800e21:	01 d0                	add    %edx,%eax
  800e23:	8a 40 04             	mov    0x4(%eax),%al
  800e26:	3c 01                	cmp    $0x1,%al
  800e28:	75 03                	jne    800e2d <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800e2a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e2d:	ff 45 e0             	incl   -0x20(%ebp)
  800e30:	a1 20 40 80 00       	mov    0x804020,%eax
  800e35:	8b 50 74             	mov    0x74(%eax),%edx
  800e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e3b:	39 c2                	cmp    %eax,%edx
  800e3d:	77 d1                	ja     800e10 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e42:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e45:	74 14                	je     800e5b <CheckWSWithoutLastIndex+0x159>
		panic(
  800e47:	83 ec 04             	sub    $0x4,%esp
  800e4a:	68 20 31 80 00       	push   $0x803120
  800e4f:	6a 44                	push   $0x44
  800e51:	68 c0 30 80 00       	push   $0x8030c0
  800e56:	e8 35 fe ff ff       	call   800c90 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e5b:	90                   	nop
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	8b 00                	mov    (%eax),%eax
  800e69:	8d 48 01             	lea    0x1(%eax),%ecx
  800e6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6f:	89 0a                	mov    %ecx,(%edx)
  800e71:	8b 55 08             	mov    0x8(%ebp),%edx
  800e74:	88 d1                	mov    %dl,%cl
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e80:	8b 00                	mov    (%eax),%eax
  800e82:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e87:	75 2c                	jne    800eb5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e89:	a0 24 40 80 00       	mov    0x804024,%al
  800e8e:	0f b6 c0             	movzbl %al,%eax
  800e91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e94:	8b 12                	mov    (%edx),%edx
  800e96:	89 d1                	mov    %edx,%ecx
  800e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9b:	83 c2 08             	add    $0x8,%edx
  800e9e:	83 ec 04             	sub    $0x4,%esp
  800ea1:	50                   	push   %eax
  800ea2:	51                   	push   %ecx
  800ea3:	52                   	push   %edx
  800ea4:	e8 a7 13 00 00       	call   802250 <sys_cputs>
  800ea9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	8b 40 04             	mov    0x4(%eax),%eax
  800ebb:	8d 50 01             	lea    0x1(%eax),%edx
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ec4:	90                   	nop
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ed0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ed7:	00 00 00 
	b.cnt = 0;
  800eda:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ee1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ee4:	ff 75 0c             	pushl  0xc(%ebp)
  800ee7:	ff 75 08             	pushl  0x8(%ebp)
  800eea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ef0:	50                   	push   %eax
  800ef1:	68 5e 0e 80 00       	push   $0x800e5e
  800ef6:	e8 11 02 00 00       	call   80110c <vprintfmt>
  800efb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800efe:	a0 24 40 80 00       	mov    0x804024,%al
  800f03:	0f b6 c0             	movzbl %al,%eax
  800f06:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f0c:	83 ec 04             	sub    $0x4,%esp
  800f0f:	50                   	push   %eax
  800f10:	52                   	push   %edx
  800f11:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f17:	83 c0 08             	add    $0x8,%eax
  800f1a:	50                   	push   %eax
  800f1b:	e8 30 13 00 00       	call   802250 <sys_cputs>
  800f20:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f23:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800f2a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <cprintf>:

int cprintf(const char *fmt, ...) {
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f38:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800f3f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	83 ec 08             	sub    $0x8,%esp
  800f4b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4e:	50                   	push   %eax
  800f4f:	e8 73 ff ff ff       	call   800ec7 <vcprintf>
  800f54:	83 c4 10             	add    $0x10,%esp
  800f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f65:	e8 f7 14 00 00       	call   802461 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f6a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	83 ec 08             	sub    $0x8,%esp
  800f76:	ff 75 f4             	pushl  -0xc(%ebp)
  800f79:	50                   	push   %eax
  800f7a:	e8 48 ff ff ff       	call   800ec7 <vcprintf>
  800f7f:	83 c4 10             	add    $0x10,%esp
  800f82:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f85:	e8 f1 14 00 00       	call   80247b <sys_enable_interrupt>
	return cnt;
  800f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f8d:	c9                   	leave  
  800f8e:	c3                   	ret    

00800f8f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	53                   	push   %ebx
  800f93:	83 ec 14             	sub    $0x14,%esp
  800f96:	8b 45 10             	mov    0x10(%ebp),%eax
  800f99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fa2:	8b 45 18             	mov    0x18(%ebp),%eax
  800fa5:	ba 00 00 00 00       	mov    $0x0,%edx
  800faa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fad:	77 55                	ja     801004 <printnum+0x75>
  800faf:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fb2:	72 05                	jb     800fb9 <printnum+0x2a>
  800fb4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fb7:	77 4b                	ja     801004 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fb9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fbc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fbf:	8b 45 18             	mov    0x18(%ebp),%eax
  800fc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc7:	52                   	push   %edx
  800fc8:	50                   	push   %eax
  800fc9:	ff 75 f4             	pushl  -0xc(%ebp)
  800fcc:	ff 75 f0             	pushl  -0x10(%ebp)
  800fcf:	e8 64 19 00 00       	call   802938 <__udivdi3>
  800fd4:	83 c4 10             	add    $0x10,%esp
  800fd7:	83 ec 04             	sub    $0x4,%esp
  800fda:	ff 75 20             	pushl  0x20(%ebp)
  800fdd:	53                   	push   %ebx
  800fde:	ff 75 18             	pushl  0x18(%ebp)
  800fe1:	52                   	push   %edx
  800fe2:	50                   	push   %eax
  800fe3:	ff 75 0c             	pushl  0xc(%ebp)
  800fe6:	ff 75 08             	pushl  0x8(%ebp)
  800fe9:	e8 a1 ff ff ff       	call   800f8f <printnum>
  800fee:	83 c4 20             	add    $0x20,%esp
  800ff1:	eb 1a                	jmp    80100d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ff3:	83 ec 08             	sub    $0x8,%esp
  800ff6:	ff 75 0c             	pushl  0xc(%ebp)
  800ff9:	ff 75 20             	pushl  0x20(%ebp)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	ff d0                	call   *%eax
  801001:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801004:	ff 4d 1c             	decl   0x1c(%ebp)
  801007:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80100b:	7f e6                	jg     800ff3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80100d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801010:	bb 00 00 00 00       	mov    $0x0,%ebx
  801015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801018:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101b:	53                   	push   %ebx
  80101c:	51                   	push   %ecx
  80101d:	52                   	push   %edx
  80101e:	50                   	push   %eax
  80101f:	e8 24 1a 00 00       	call   802a48 <__umoddi3>
  801024:	83 c4 10             	add    $0x10,%esp
  801027:	05 94 33 80 00       	add    $0x803394,%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	0f be c0             	movsbl %al,%eax
  801031:	83 ec 08             	sub    $0x8,%esp
  801034:	ff 75 0c             	pushl  0xc(%ebp)
  801037:	50                   	push   %eax
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	ff d0                	call   *%eax
  80103d:	83 c4 10             	add    $0x10,%esp
}
  801040:	90                   	nop
  801041:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801049:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80104d:	7e 1c                	jle    80106b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	8b 00                	mov    (%eax),%eax
  801054:	8d 50 08             	lea    0x8(%eax),%edx
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	89 10                	mov    %edx,(%eax)
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8b 00                	mov    (%eax),%eax
  801061:	83 e8 08             	sub    $0x8,%eax
  801064:	8b 50 04             	mov    0x4(%eax),%edx
  801067:	8b 00                	mov    (%eax),%eax
  801069:	eb 40                	jmp    8010ab <getuint+0x65>
	else if (lflag)
  80106b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80106f:	74 1e                	je     80108f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	8b 00                	mov    (%eax),%eax
  801076:	8d 50 04             	lea    0x4(%eax),%edx
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	89 10                	mov    %edx,(%eax)
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8b 00                	mov    (%eax),%eax
  801083:	83 e8 04             	sub    $0x4,%eax
  801086:	8b 00                	mov    (%eax),%eax
  801088:	ba 00 00 00 00       	mov    $0x0,%edx
  80108d:	eb 1c                	jmp    8010ab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8b 00                	mov    (%eax),%eax
  801094:	8d 50 04             	lea    0x4(%eax),%edx
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	89 10                	mov    %edx,(%eax)
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8b 00                	mov    (%eax),%eax
  8010a1:	83 e8 04             	sub    $0x4,%eax
  8010a4:	8b 00                	mov    (%eax),%eax
  8010a6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010ab:	5d                   	pop    %ebp
  8010ac:	c3                   	ret    

008010ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010b4:	7e 1c                	jle    8010d2 <getint+0x25>
		return va_arg(*ap, long long);
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8b 00                	mov    (%eax),%eax
  8010bb:	8d 50 08             	lea    0x8(%eax),%edx
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	89 10                	mov    %edx,(%eax)
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8b 00                	mov    (%eax),%eax
  8010c8:	83 e8 08             	sub    $0x8,%eax
  8010cb:	8b 50 04             	mov    0x4(%eax),%edx
  8010ce:	8b 00                	mov    (%eax),%eax
  8010d0:	eb 38                	jmp    80110a <getint+0x5d>
	else if (lflag)
  8010d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d6:	74 1a                	je     8010f2 <getint+0x45>
		return va_arg(*ap, long);
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8b 00                	mov    (%eax),%eax
  8010dd:	8d 50 04             	lea    0x4(%eax),%edx
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	89 10                	mov    %edx,(%eax)
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8b 00                	mov    (%eax),%eax
  8010ea:	83 e8 04             	sub    $0x4,%eax
  8010ed:	8b 00                	mov    (%eax),%eax
  8010ef:	99                   	cltd   
  8010f0:	eb 18                	jmp    80110a <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	8b 00                	mov    (%eax),%eax
  8010f7:	8d 50 04             	lea    0x4(%eax),%edx
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	89 10                	mov    %edx,(%eax)
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	8b 00                	mov    (%eax),%eax
  801104:	83 e8 04             	sub    $0x4,%eax
  801107:	8b 00                	mov    (%eax),%eax
  801109:	99                   	cltd   
}
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    

0080110c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	56                   	push   %esi
  801110:	53                   	push   %ebx
  801111:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801114:	eb 17                	jmp    80112d <vprintfmt+0x21>
			if (ch == '\0')
  801116:	85 db                	test   %ebx,%ebx
  801118:	0f 84 af 03 00 00    	je     8014cd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80111e:	83 ec 08             	sub    $0x8,%esp
  801121:	ff 75 0c             	pushl  0xc(%ebp)
  801124:	53                   	push   %ebx
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	ff d0                	call   *%eax
  80112a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80112d:	8b 45 10             	mov    0x10(%ebp),%eax
  801130:	8d 50 01             	lea    0x1(%eax),%edx
  801133:	89 55 10             	mov    %edx,0x10(%ebp)
  801136:	8a 00                	mov    (%eax),%al
  801138:	0f b6 d8             	movzbl %al,%ebx
  80113b:	83 fb 25             	cmp    $0x25,%ebx
  80113e:	75 d6                	jne    801116 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801140:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801144:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80114b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801152:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801159:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801160:	8b 45 10             	mov    0x10(%ebp),%eax
  801163:	8d 50 01             	lea    0x1(%eax),%edx
  801166:	89 55 10             	mov    %edx,0x10(%ebp)
  801169:	8a 00                	mov    (%eax),%al
  80116b:	0f b6 d8             	movzbl %al,%ebx
  80116e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801171:	83 f8 55             	cmp    $0x55,%eax
  801174:	0f 87 2b 03 00 00    	ja     8014a5 <vprintfmt+0x399>
  80117a:	8b 04 85 b8 33 80 00 	mov    0x8033b8(,%eax,4),%eax
  801181:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801183:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801187:	eb d7                	jmp    801160 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801189:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80118d:	eb d1                	jmp    801160 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80118f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801196:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801199:	89 d0                	mov    %edx,%eax
  80119b:	c1 e0 02             	shl    $0x2,%eax
  80119e:	01 d0                	add    %edx,%eax
  8011a0:	01 c0                	add    %eax,%eax
  8011a2:	01 d8                	add    %ebx,%eax
  8011a4:	83 e8 30             	sub    $0x30,%eax
  8011a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8011b5:	7e 3e                	jle    8011f5 <vprintfmt+0xe9>
  8011b7:	83 fb 39             	cmp    $0x39,%ebx
  8011ba:	7f 39                	jg     8011f5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011bc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011bf:	eb d5                	jmp    801196 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c4:	83 c0 04             	add    $0x4,%eax
  8011c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8011ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cd:	83 e8 04             	sub    $0x4,%eax
  8011d0:	8b 00                	mov    (%eax),%eax
  8011d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011d5:	eb 1f                	jmp    8011f6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011db:	79 83                	jns    801160 <vprintfmt+0x54>
				width = 0;
  8011dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011e4:	e9 77 ff ff ff       	jmp    801160 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011e9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011f0:	e9 6b ff ff ff       	jmp    801160 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011f5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011fa:	0f 89 60 ff ff ff    	jns    801160 <vprintfmt+0x54>
				width = precision, precision = -1;
  801200:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801203:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801206:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80120d:	e9 4e ff ff ff       	jmp    801160 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801212:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801215:	e9 46 ff ff ff       	jmp    801160 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80121a:	8b 45 14             	mov    0x14(%ebp),%eax
  80121d:	83 c0 04             	add    $0x4,%eax
  801220:	89 45 14             	mov    %eax,0x14(%ebp)
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	83 e8 04             	sub    $0x4,%eax
  801229:	8b 00                	mov    (%eax),%eax
  80122b:	83 ec 08             	sub    $0x8,%esp
  80122e:	ff 75 0c             	pushl  0xc(%ebp)
  801231:	50                   	push   %eax
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	ff d0                	call   *%eax
  801237:	83 c4 10             	add    $0x10,%esp
			break;
  80123a:	e9 89 02 00 00       	jmp    8014c8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80123f:	8b 45 14             	mov    0x14(%ebp),%eax
  801242:	83 c0 04             	add    $0x4,%eax
  801245:	89 45 14             	mov    %eax,0x14(%ebp)
  801248:	8b 45 14             	mov    0x14(%ebp),%eax
  80124b:	83 e8 04             	sub    $0x4,%eax
  80124e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801250:	85 db                	test   %ebx,%ebx
  801252:	79 02                	jns    801256 <vprintfmt+0x14a>
				err = -err;
  801254:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801256:	83 fb 64             	cmp    $0x64,%ebx
  801259:	7f 0b                	jg     801266 <vprintfmt+0x15a>
  80125b:	8b 34 9d 00 32 80 00 	mov    0x803200(,%ebx,4),%esi
  801262:	85 f6                	test   %esi,%esi
  801264:	75 19                	jne    80127f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801266:	53                   	push   %ebx
  801267:	68 a5 33 80 00       	push   $0x8033a5
  80126c:	ff 75 0c             	pushl  0xc(%ebp)
  80126f:	ff 75 08             	pushl  0x8(%ebp)
  801272:	e8 5e 02 00 00       	call   8014d5 <printfmt>
  801277:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80127a:	e9 49 02 00 00       	jmp    8014c8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80127f:	56                   	push   %esi
  801280:	68 ae 33 80 00       	push   $0x8033ae
  801285:	ff 75 0c             	pushl  0xc(%ebp)
  801288:	ff 75 08             	pushl  0x8(%ebp)
  80128b:	e8 45 02 00 00       	call   8014d5 <printfmt>
  801290:	83 c4 10             	add    $0x10,%esp
			break;
  801293:	e9 30 02 00 00       	jmp    8014c8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801298:	8b 45 14             	mov    0x14(%ebp),%eax
  80129b:	83 c0 04             	add    $0x4,%eax
  80129e:	89 45 14             	mov    %eax,0x14(%ebp)
  8012a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a4:	83 e8 04             	sub    $0x4,%eax
  8012a7:	8b 30                	mov    (%eax),%esi
  8012a9:	85 f6                	test   %esi,%esi
  8012ab:	75 05                	jne    8012b2 <vprintfmt+0x1a6>
				p = "(null)";
  8012ad:	be b1 33 80 00       	mov    $0x8033b1,%esi
			if (width > 0 && padc != '-')
  8012b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012b6:	7e 6d                	jle    801325 <vprintfmt+0x219>
  8012b8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012bc:	74 67                	je     801325 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012c1:	83 ec 08             	sub    $0x8,%esp
  8012c4:	50                   	push   %eax
  8012c5:	56                   	push   %esi
  8012c6:	e8 0c 03 00 00       	call   8015d7 <strnlen>
  8012cb:	83 c4 10             	add    $0x10,%esp
  8012ce:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012d1:	eb 16                	jmp    8012e9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012d3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012d7:	83 ec 08             	sub    $0x8,%esp
  8012da:	ff 75 0c             	pushl  0xc(%ebp)
  8012dd:	50                   	push   %eax
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	ff d0                	call   *%eax
  8012e3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8012e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012ed:	7f e4                	jg     8012d3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012ef:	eb 34                	jmp    801325 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012f5:	74 1c                	je     801313 <vprintfmt+0x207>
  8012f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8012fa:	7e 05                	jle    801301 <vprintfmt+0x1f5>
  8012fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8012ff:	7e 12                	jle    801313 <vprintfmt+0x207>
					putch('?', putdat);
  801301:	83 ec 08             	sub    $0x8,%esp
  801304:	ff 75 0c             	pushl  0xc(%ebp)
  801307:	6a 3f                	push   $0x3f
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	ff d0                	call   *%eax
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	eb 0f                	jmp    801322 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801313:	83 ec 08             	sub    $0x8,%esp
  801316:	ff 75 0c             	pushl  0xc(%ebp)
  801319:	53                   	push   %ebx
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	ff d0                	call   *%eax
  80131f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801322:	ff 4d e4             	decl   -0x1c(%ebp)
  801325:	89 f0                	mov    %esi,%eax
  801327:	8d 70 01             	lea    0x1(%eax),%esi
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	0f be d8             	movsbl %al,%ebx
  80132f:	85 db                	test   %ebx,%ebx
  801331:	74 24                	je     801357 <vprintfmt+0x24b>
  801333:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801337:	78 b8                	js     8012f1 <vprintfmt+0x1e5>
  801339:	ff 4d e0             	decl   -0x20(%ebp)
  80133c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801340:	79 af                	jns    8012f1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801342:	eb 13                	jmp    801357 <vprintfmt+0x24b>
				putch(' ', putdat);
  801344:	83 ec 08             	sub    $0x8,%esp
  801347:	ff 75 0c             	pushl  0xc(%ebp)
  80134a:	6a 20                	push   $0x20
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	ff d0                	call   *%eax
  801351:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801354:	ff 4d e4             	decl   -0x1c(%ebp)
  801357:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80135b:	7f e7                	jg     801344 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80135d:	e9 66 01 00 00       	jmp    8014c8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801362:	83 ec 08             	sub    $0x8,%esp
  801365:	ff 75 e8             	pushl  -0x18(%ebp)
  801368:	8d 45 14             	lea    0x14(%ebp),%eax
  80136b:	50                   	push   %eax
  80136c:	e8 3c fd ff ff       	call   8010ad <getint>
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801377:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80137a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801380:	85 d2                	test   %edx,%edx
  801382:	79 23                	jns    8013a7 <vprintfmt+0x29b>
				putch('-', putdat);
  801384:	83 ec 08             	sub    $0x8,%esp
  801387:	ff 75 0c             	pushl  0xc(%ebp)
  80138a:	6a 2d                	push   $0x2d
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	ff d0                	call   *%eax
  801391:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801397:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139a:	f7 d8                	neg    %eax
  80139c:	83 d2 00             	adc    $0x0,%edx
  80139f:	f7 da                	neg    %edx
  8013a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013a7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013ae:	e9 bc 00 00 00       	jmp    80146f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8013b9:	8d 45 14             	lea    0x14(%ebp),%eax
  8013bc:	50                   	push   %eax
  8013bd:	e8 84 fc ff ff       	call   801046 <getuint>
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013d2:	e9 98 00 00 00       	jmp    80146f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	6a 58                	push   $0x58
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	ff d0                	call   *%eax
  8013e4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	ff 75 0c             	pushl  0xc(%ebp)
  8013ed:	6a 58                	push   $0x58
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	ff d0                	call   *%eax
  8013f4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013f7:	83 ec 08             	sub    $0x8,%esp
  8013fa:	ff 75 0c             	pushl  0xc(%ebp)
  8013fd:	6a 58                	push   $0x58
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	ff d0                	call   *%eax
  801404:	83 c4 10             	add    $0x10,%esp
			break;
  801407:	e9 bc 00 00 00       	jmp    8014c8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80140c:	83 ec 08             	sub    $0x8,%esp
  80140f:	ff 75 0c             	pushl  0xc(%ebp)
  801412:	6a 30                	push   $0x30
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	ff d0                	call   *%eax
  801419:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80141c:	83 ec 08             	sub    $0x8,%esp
  80141f:	ff 75 0c             	pushl  0xc(%ebp)
  801422:	6a 78                	push   $0x78
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	ff d0                	call   *%eax
  801429:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80142c:	8b 45 14             	mov    0x14(%ebp),%eax
  80142f:	83 c0 04             	add    $0x4,%eax
  801432:	89 45 14             	mov    %eax,0x14(%ebp)
  801435:	8b 45 14             	mov    0x14(%ebp),%eax
  801438:	83 e8 04             	sub    $0x4,%eax
  80143b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80143d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801440:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801447:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80144e:	eb 1f                	jmp    80146f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801450:	83 ec 08             	sub    $0x8,%esp
  801453:	ff 75 e8             	pushl  -0x18(%ebp)
  801456:	8d 45 14             	lea    0x14(%ebp),%eax
  801459:	50                   	push   %eax
  80145a:	e8 e7 fb ff ff       	call   801046 <getuint>
  80145f:	83 c4 10             	add    $0x10,%esp
  801462:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801465:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801468:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80146f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801473:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801476:	83 ec 04             	sub    $0x4,%esp
  801479:	52                   	push   %edx
  80147a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80147d:	50                   	push   %eax
  80147e:	ff 75 f4             	pushl  -0xc(%ebp)
  801481:	ff 75 f0             	pushl  -0x10(%ebp)
  801484:	ff 75 0c             	pushl  0xc(%ebp)
  801487:	ff 75 08             	pushl  0x8(%ebp)
  80148a:	e8 00 fb ff ff       	call   800f8f <printnum>
  80148f:	83 c4 20             	add    $0x20,%esp
			break;
  801492:	eb 34                	jmp    8014c8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801494:	83 ec 08             	sub    $0x8,%esp
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	53                   	push   %ebx
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	ff d0                	call   *%eax
  8014a0:	83 c4 10             	add    $0x10,%esp
			break;
  8014a3:	eb 23                	jmp    8014c8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014a5:	83 ec 08             	sub    $0x8,%esp
  8014a8:	ff 75 0c             	pushl  0xc(%ebp)
  8014ab:	6a 25                	push   $0x25
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	ff d0                	call   *%eax
  8014b2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014b5:	ff 4d 10             	decl   0x10(%ebp)
  8014b8:	eb 03                	jmp    8014bd <vprintfmt+0x3b1>
  8014ba:	ff 4d 10             	decl   0x10(%ebp)
  8014bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c0:	48                   	dec    %eax
  8014c1:	8a 00                	mov    (%eax),%al
  8014c3:	3c 25                	cmp    $0x25,%al
  8014c5:	75 f3                	jne    8014ba <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014c7:	90                   	nop
		}
	}
  8014c8:	e9 47 fc ff ff       	jmp    801114 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014cd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d1:	5b                   	pop    %ebx
  8014d2:	5e                   	pop    %esi
  8014d3:	5d                   	pop    %ebp
  8014d4:	c3                   	ret    

008014d5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014db:	8d 45 10             	lea    0x10(%ebp),%eax
  8014de:	83 c0 04             	add    $0x4,%eax
  8014e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8014ea:	50                   	push   %eax
  8014eb:	ff 75 0c             	pushl  0xc(%ebp)
  8014ee:	ff 75 08             	pushl  0x8(%ebp)
  8014f1:	e8 16 fc ff ff       	call   80110c <vprintfmt>
  8014f6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014f9:	90                   	nop
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801502:	8b 40 08             	mov    0x8(%eax),%eax
  801505:	8d 50 01             	lea    0x1(%eax),%edx
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80150e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801511:	8b 10                	mov    (%eax),%edx
  801513:	8b 45 0c             	mov    0xc(%ebp),%eax
  801516:	8b 40 04             	mov    0x4(%eax),%eax
  801519:	39 c2                	cmp    %eax,%edx
  80151b:	73 12                	jae    80152f <sprintputch+0x33>
		*b->buf++ = ch;
  80151d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801520:	8b 00                	mov    (%eax),%eax
  801522:	8d 48 01             	lea    0x1(%eax),%ecx
  801525:	8b 55 0c             	mov    0xc(%ebp),%edx
  801528:	89 0a                	mov    %ecx,(%edx)
  80152a:	8b 55 08             	mov    0x8(%ebp),%edx
  80152d:	88 10                	mov    %dl,(%eax)
}
  80152f:	90                   	nop
  801530:	5d                   	pop    %ebp
  801531:	c3                   	ret    

00801532 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80153e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801541:	8d 50 ff             	lea    -0x1(%eax),%edx
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	01 d0                	add    %edx,%eax
  801549:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80154c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801553:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801557:	74 06                	je     80155f <vsnprintf+0x2d>
  801559:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80155d:	7f 07                	jg     801566 <vsnprintf+0x34>
		return -E_INVAL;
  80155f:	b8 03 00 00 00       	mov    $0x3,%eax
  801564:	eb 20                	jmp    801586 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801566:	ff 75 14             	pushl  0x14(%ebp)
  801569:	ff 75 10             	pushl  0x10(%ebp)
  80156c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80156f:	50                   	push   %eax
  801570:	68 fc 14 80 00       	push   $0x8014fc
  801575:	e8 92 fb ff ff       	call   80110c <vprintfmt>
  80157a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80157d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801580:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801583:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80158e:	8d 45 10             	lea    0x10(%ebp),%eax
  801591:	83 c0 04             	add    $0x4,%eax
  801594:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801597:	8b 45 10             	mov    0x10(%ebp),%eax
  80159a:	ff 75 f4             	pushl  -0xc(%ebp)
  80159d:	50                   	push   %eax
  80159e:	ff 75 0c             	pushl  0xc(%ebp)
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	e8 89 ff ff ff       	call   801532 <vsnprintf>
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015af:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015c1:	eb 06                	jmp    8015c9 <strlen+0x15>
		n++;
  8015c3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015c6:	ff 45 08             	incl   0x8(%ebp)
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8a 00                	mov    (%eax),%al
  8015ce:	84 c0                	test   %al,%al
  8015d0:	75 f1                	jne    8015c3 <strlen+0xf>
		n++;
	return n;
  8015d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e4:	eb 09                	jmp    8015ef <strnlen+0x18>
		n++;
  8015e6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015e9:	ff 45 08             	incl   0x8(%ebp)
  8015ec:	ff 4d 0c             	decl   0xc(%ebp)
  8015ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015f3:	74 09                	je     8015fe <strnlen+0x27>
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	75 e8                	jne    8015e6 <strnlen+0xf>
		n++;
	return n;
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80160f:	90                   	nop
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	8d 50 01             	lea    0x1(%eax),%edx
  801616:	89 55 08             	mov    %edx,0x8(%ebp)
  801619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801622:	8a 12                	mov    (%edx),%dl
  801624:	88 10                	mov    %dl,(%eax)
  801626:	8a 00                	mov    (%eax),%al
  801628:	84 c0                	test   %al,%al
  80162a:	75 e4                	jne    801610 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80162c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80163d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801644:	eb 1f                	jmp    801665 <strncpy+0x34>
		*dst++ = *src;
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8d 50 01             	lea    0x1(%eax),%edx
  80164c:	89 55 08             	mov    %edx,0x8(%ebp)
  80164f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801652:	8a 12                	mov    (%edx),%dl
  801654:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801656:	8b 45 0c             	mov    0xc(%ebp),%eax
  801659:	8a 00                	mov    (%eax),%al
  80165b:	84 c0                	test   %al,%al
  80165d:	74 03                	je     801662 <strncpy+0x31>
			src++;
  80165f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801662:	ff 45 fc             	incl   -0x4(%ebp)
  801665:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801668:	3b 45 10             	cmp    0x10(%ebp),%eax
  80166b:	72 d9                	jb     801646 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80166d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80167e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801682:	74 30                	je     8016b4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801684:	eb 16                	jmp    80169c <strlcpy+0x2a>
			*dst++ = *src++;
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	8d 50 01             	lea    0x1(%eax),%edx
  80168c:	89 55 08             	mov    %edx,0x8(%ebp)
  80168f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801692:	8d 4a 01             	lea    0x1(%edx),%ecx
  801695:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801698:	8a 12                	mov    (%edx),%dl
  80169a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80169c:	ff 4d 10             	decl   0x10(%ebp)
  80169f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a3:	74 09                	je     8016ae <strlcpy+0x3c>
  8016a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a8:	8a 00                	mov    (%eax),%al
  8016aa:	84 c0                	test   %al,%al
  8016ac:	75 d8                	jne    801686 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ba:	29 c2                	sub    %eax,%edx
  8016bc:	89 d0                	mov    %edx,%eax
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016c3:	eb 06                	jmp    8016cb <strcmp+0xb>
		p++, q++;
  8016c5:	ff 45 08             	incl   0x8(%ebp)
  8016c8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	8a 00                	mov    (%eax),%al
  8016d0:	84 c0                	test   %al,%al
  8016d2:	74 0e                	je     8016e2 <strcmp+0x22>
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	8a 10                	mov    (%eax),%dl
  8016d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dc:	8a 00                	mov    (%eax),%al
  8016de:	38 c2                	cmp    %al,%dl
  8016e0:	74 e3                	je     8016c5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	8a 00                	mov    (%eax),%al
  8016e7:	0f b6 d0             	movzbl %al,%edx
  8016ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ed:	8a 00                	mov    (%eax),%al
  8016ef:	0f b6 c0             	movzbl %al,%eax
  8016f2:	29 c2                	sub    %eax,%edx
  8016f4:	89 d0                	mov    %edx,%eax
}
  8016f6:	5d                   	pop    %ebp
  8016f7:	c3                   	ret    

008016f8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016fb:	eb 09                	jmp    801706 <strncmp+0xe>
		n--, p++, q++;
  8016fd:	ff 4d 10             	decl   0x10(%ebp)
  801700:	ff 45 08             	incl   0x8(%ebp)
  801703:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801706:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80170a:	74 17                	je     801723 <strncmp+0x2b>
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	8a 00                	mov    (%eax),%al
  801711:	84 c0                	test   %al,%al
  801713:	74 0e                	je     801723 <strncmp+0x2b>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 10                	mov    (%eax),%dl
  80171a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	38 c2                	cmp    %al,%dl
  801721:	74 da                	je     8016fd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801723:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801727:	75 07                	jne    801730 <strncmp+0x38>
		return 0;
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
  80172e:	eb 14                	jmp    801744 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	8a 00                	mov    (%eax),%al
  801735:	0f b6 d0             	movzbl %al,%edx
  801738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	0f b6 c0             	movzbl %al,%eax
  801740:	29 c2                	sub    %eax,%edx
  801742:	89 d0                	mov    %edx,%eax
}
  801744:	5d                   	pop    %ebp
  801745:	c3                   	ret    

00801746 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801752:	eb 12                	jmp    801766 <strchr+0x20>
		if (*s == c)
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	8a 00                	mov    (%eax),%al
  801759:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80175c:	75 05                	jne    801763 <strchr+0x1d>
			return (char *) s;
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	eb 11                	jmp    801774 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801763:	ff 45 08             	incl   0x8(%ebp)
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	8a 00                	mov    (%eax),%al
  80176b:	84 c0                	test   %al,%al
  80176d:	75 e5                	jne    801754 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80176f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 04             	sub    $0x4,%esp
  80177c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801782:	eb 0d                	jmp    801791 <strfind+0x1b>
		if (*s == c)
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8a 00                	mov    (%eax),%al
  801789:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80178c:	74 0e                	je     80179c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80178e:	ff 45 08             	incl   0x8(%ebp)
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	84 c0                	test   %al,%al
  801798:	75 ea                	jne    801784 <strfind+0xe>
  80179a:	eb 01                	jmp    80179d <strfind+0x27>
		if (*s == c)
			break;
  80179c:	90                   	nop
	return (char *) s;
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017b4:	eb 0e                	jmp    8017c4 <memset+0x22>
		*p++ = c;
  8017b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017b9:	8d 50 01             	lea    0x1(%eax),%edx
  8017bc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017c4:	ff 4d f8             	decl   -0x8(%ebp)
  8017c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017cb:	79 e9                	jns    8017b6 <memset+0x14>
		*p++ = c;

	return v;
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017e4:	eb 16                	jmp    8017fc <memcpy+0x2a>
		*d++ = *s++;
  8017e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e9:	8d 50 01             	lea    0x1(%eax),%edx
  8017ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017f5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017f8:	8a 12                	mov    (%edx),%dl
  8017fa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801802:	89 55 10             	mov    %edx,0x10(%ebp)
  801805:	85 c0                	test   %eax,%eax
  801807:	75 dd                	jne    8017e6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801814:	8b 45 0c             	mov    0xc(%ebp),%eax
  801817:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801820:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801823:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801826:	73 50                	jae    801878 <memmove+0x6a>
  801828:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80182b:	8b 45 10             	mov    0x10(%ebp),%eax
  80182e:	01 d0                	add    %edx,%eax
  801830:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801833:	76 43                	jbe    801878 <memmove+0x6a>
		s += n;
  801835:	8b 45 10             	mov    0x10(%ebp),%eax
  801838:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80183b:	8b 45 10             	mov    0x10(%ebp),%eax
  80183e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801841:	eb 10                	jmp    801853 <memmove+0x45>
			*--d = *--s;
  801843:	ff 4d f8             	decl   -0x8(%ebp)
  801846:	ff 4d fc             	decl   -0x4(%ebp)
  801849:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184c:	8a 10                	mov    (%eax),%dl
  80184e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801851:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801853:	8b 45 10             	mov    0x10(%ebp),%eax
  801856:	8d 50 ff             	lea    -0x1(%eax),%edx
  801859:	89 55 10             	mov    %edx,0x10(%ebp)
  80185c:	85 c0                	test   %eax,%eax
  80185e:	75 e3                	jne    801843 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801860:	eb 23                	jmp    801885 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801862:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801865:	8d 50 01             	lea    0x1(%eax),%edx
  801868:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80186b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80186e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801871:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801874:	8a 12                	mov    (%edx),%dl
  801876:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801878:	8b 45 10             	mov    0x10(%ebp),%eax
  80187b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80187e:	89 55 10             	mov    %edx,0x10(%ebp)
  801881:	85 c0                	test   %eax,%eax
  801883:	75 dd                	jne    801862 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801896:	8b 45 0c             	mov    0xc(%ebp),%eax
  801899:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80189c:	eb 2a                	jmp    8018c8 <memcmp+0x3e>
		if (*s1 != *s2)
  80189e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a1:	8a 10                	mov    (%eax),%dl
  8018a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a6:	8a 00                	mov    (%eax),%al
  8018a8:	38 c2                	cmp    %al,%dl
  8018aa:	74 16                	je     8018c2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018af:	8a 00                	mov    (%eax),%al
  8018b1:	0f b6 d0             	movzbl %al,%edx
  8018b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b7:	8a 00                	mov    (%eax),%al
  8018b9:	0f b6 c0             	movzbl %al,%eax
  8018bc:	29 c2                	sub    %eax,%edx
  8018be:	89 d0                	mov    %edx,%eax
  8018c0:	eb 18                	jmp    8018da <memcmp+0x50>
		s1++, s2++;
  8018c2:	ff 45 fc             	incl   -0x4(%ebp)
  8018c5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	75 c9                	jne    80189e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 d0                	add    %edx,%eax
  8018ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018ed:	eb 15                	jmp    801904 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	8a 00                	mov    (%eax),%al
  8018f4:	0f b6 d0             	movzbl %al,%edx
  8018f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fa:	0f b6 c0             	movzbl %al,%eax
  8018fd:	39 c2                	cmp    %eax,%edx
  8018ff:	74 0d                	je     80190e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801901:	ff 45 08             	incl   0x8(%ebp)
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80190a:	72 e3                	jb     8018ef <memfind+0x13>
  80190c:	eb 01                	jmp    80190f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80190e:	90                   	nop
	return (void *) s;
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80191a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801921:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801928:	eb 03                	jmp    80192d <strtol+0x19>
		s++;
  80192a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	8a 00                	mov    (%eax),%al
  801932:	3c 20                	cmp    $0x20,%al
  801934:	74 f4                	je     80192a <strtol+0x16>
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	8a 00                	mov    (%eax),%al
  80193b:	3c 09                	cmp    $0x9,%al
  80193d:	74 eb                	je     80192a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	8a 00                	mov    (%eax),%al
  801944:	3c 2b                	cmp    $0x2b,%al
  801946:	75 05                	jne    80194d <strtol+0x39>
		s++;
  801948:	ff 45 08             	incl   0x8(%ebp)
  80194b:	eb 13                	jmp    801960 <strtol+0x4c>
	else if (*s == '-')
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	8a 00                	mov    (%eax),%al
  801952:	3c 2d                	cmp    $0x2d,%al
  801954:	75 0a                	jne    801960 <strtol+0x4c>
		s++, neg = 1;
  801956:	ff 45 08             	incl   0x8(%ebp)
  801959:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801960:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801964:	74 06                	je     80196c <strtol+0x58>
  801966:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80196a:	75 20                	jne    80198c <strtol+0x78>
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	8a 00                	mov    (%eax),%al
  801971:	3c 30                	cmp    $0x30,%al
  801973:	75 17                	jne    80198c <strtol+0x78>
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	40                   	inc    %eax
  801979:	8a 00                	mov    (%eax),%al
  80197b:	3c 78                	cmp    $0x78,%al
  80197d:	75 0d                	jne    80198c <strtol+0x78>
		s += 2, base = 16;
  80197f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801983:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80198a:	eb 28                	jmp    8019b4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80198c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801990:	75 15                	jne    8019a7 <strtol+0x93>
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	8a 00                	mov    (%eax),%al
  801997:	3c 30                	cmp    $0x30,%al
  801999:	75 0c                	jne    8019a7 <strtol+0x93>
		s++, base = 8;
  80199b:	ff 45 08             	incl   0x8(%ebp)
  80199e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019a5:	eb 0d                	jmp    8019b4 <strtol+0xa0>
	else if (base == 0)
  8019a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019ab:	75 07                	jne    8019b4 <strtol+0xa0>
		base = 10;
  8019ad:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	8a 00                	mov    (%eax),%al
  8019b9:	3c 2f                	cmp    $0x2f,%al
  8019bb:	7e 19                	jle    8019d6 <strtol+0xc2>
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8a 00                	mov    (%eax),%al
  8019c2:	3c 39                	cmp    $0x39,%al
  8019c4:	7f 10                	jg     8019d6 <strtol+0xc2>
			dig = *s - '0';
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8a 00                	mov    (%eax),%al
  8019cb:	0f be c0             	movsbl %al,%eax
  8019ce:	83 e8 30             	sub    $0x30,%eax
  8019d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019d4:	eb 42                	jmp    801a18 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	8a 00                	mov    (%eax),%al
  8019db:	3c 60                	cmp    $0x60,%al
  8019dd:	7e 19                	jle    8019f8 <strtol+0xe4>
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8a 00                	mov    (%eax),%al
  8019e4:	3c 7a                	cmp    $0x7a,%al
  8019e6:	7f 10                	jg     8019f8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8a 00                	mov    (%eax),%al
  8019ed:	0f be c0             	movsbl %al,%eax
  8019f0:	83 e8 57             	sub    $0x57,%eax
  8019f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019f6:	eb 20                	jmp    801a18 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	8a 00                	mov    (%eax),%al
  8019fd:	3c 40                	cmp    $0x40,%al
  8019ff:	7e 39                	jle    801a3a <strtol+0x126>
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	3c 5a                	cmp    $0x5a,%al
  801a08:	7f 30                	jg     801a3a <strtol+0x126>
			dig = *s - 'A' + 10;
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	0f be c0             	movsbl %al,%eax
  801a12:	83 e8 37             	sub    $0x37,%eax
  801a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1b:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a1e:	7d 19                	jge    801a39 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a20:	ff 45 08             	incl   0x8(%ebp)
  801a23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a26:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a2a:	89 c2                	mov    %eax,%edx
  801a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2f:	01 d0                	add    %edx,%eax
  801a31:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a34:	e9 7b ff ff ff       	jmp    8019b4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a39:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a3e:	74 08                	je     801a48 <strtol+0x134>
		*endptr = (char *) s;
  801a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a43:	8b 55 08             	mov    0x8(%ebp),%edx
  801a46:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a48:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a4c:	74 07                	je     801a55 <strtol+0x141>
  801a4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a51:	f7 d8                	neg    %eax
  801a53:	eb 03                	jmp    801a58 <strtol+0x144>
  801a55:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <ltostr>:

void
ltostr(long value, char *str)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a67:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a72:	79 13                	jns    801a87 <ltostr+0x2d>
	{
		neg = 1;
  801a74:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a81:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a84:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a8f:	99                   	cltd   
  801a90:	f7 f9                	idiv   %ecx
  801a92:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a98:	8d 50 01             	lea    0x1(%eax),%edx
  801a9b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a9e:	89 c2                	mov    %eax,%edx
  801aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa3:	01 d0                	add    %edx,%eax
  801aa5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801aa8:	83 c2 30             	add    $0x30,%edx
  801aab:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801aad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ab5:	f7 e9                	imul   %ecx
  801ab7:	c1 fa 02             	sar    $0x2,%edx
  801aba:	89 c8                	mov    %ecx,%eax
  801abc:	c1 f8 1f             	sar    $0x1f,%eax
  801abf:	29 c2                	sub    %eax,%edx
  801ac1:	89 d0                	mov    %edx,%eax
  801ac3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801ac6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ac9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ace:	f7 e9                	imul   %ecx
  801ad0:	c1 fa 02             	sar    $0x2,%edx
  801ad3:	89 c8                	mov    %ecx,%eax
  801ad5:	c1 f8 1f             	sar    $0x1f,%eax
  801ad8:	29 c2                	sub    %eax,%edx
  801ada:	89 d0                	mov    %edx,%eax
  801adc:	c1 e0 02             	shl    $0x2,%eax
  801adf:	01 d0                	add    %edx,%eax
  801ae1:	01 c0                	add    %eax,%eax
  801ae3:	29 c1                	sub    %eax,%ecx
  801ae5:	89 ca                	mov    %ecx,%edx
  801ae7:	85 d2                	test   %edx,%edx
  801ae9:	75 9c                	jne    801a87 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801aeb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801af2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801af5:	48                   	dec    %eax
  801af6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801af9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801afd:	74 3d                	je     801b3c <ltostr+0xe2>
		start = 1 ;
  801aff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b06:	eb 34                	jmp    801b3c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0e:	01 d0                	add    %edx,%eax
  801b10:	8a 00                	mov    (%eax),%al
  801b12:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1b:	01 c2                	add    %eax,%edx
  801b1d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b23:	01 c8                	add    %ecx,%eax
  801b25:	8a 00                	mov    (%eax),%al
  801b27:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2f:	01 c2                	add    %eax,%edx
  801b31:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b34:	88 02                	mov    %al,(%edx)
		start++ ;
  801b36:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b39:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b42:	7c c4                	jl     801b08 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b44:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4a:	01 d0                	add    %edx,%eax
  801b4c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b4f:	90                   	nop
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b58:	ff 75 08             	pushl  0x8(%ebp)
  801b5b:	e8 54 fa ff ff       	call   8015b4 <strlen>
  801b60:	83 c4 04             	add    $0x4,%esp
  801b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b66:	ff 75 0c             	pushl  0xc(%ebp)
  801b69:	e8 46 fa ff ff       	call   8015b4 <strlen>
  801b6e:	83 c4 04             	add    $0x4,%esp
  801b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b82:	eb 17                	jmp    801b9b <strcconcat+0x49>
		final[s] = str1[s] ;
  801b84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b87:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8a:	01 c2                	add    %eax,%edx
  801b8c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	01 c8                	add    %ecx,%eax
  801b94:	8a 00                	mov    (%eax),%al
  801b96:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b98:	ff 45 fc             	incl   -0x4(%ebp)
  801b9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b9e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ba1:	7c e1                	jl     801b84 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801ba3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801baa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bb1:	eb 1f                	jmp    801bd2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bb6:	8d 50 01             	lea    0x1(%eax),%edx
  801bb9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bbc:	89 c2                	mov    %eax,%edx
  801bbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc1:	01 c2                	add    %eax,%edx
  801bc3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc9:	01 c8                	add    %ecx,%eax
  801bcb:	8a 00                	mov    (%eax),%al
  801bcd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bcf:	ff 45 f8             	incl   -0x8(%ebp)
  801bd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bd5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bd8:	7c d9                	jl     801bb3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801bda:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bdd:	8b 45 10             	mov    0x10(%ebp),%eax
  801be0:	01 d0                	add    %edx,%eax
  801be2:	c6 00 00             	movb   $0x0,(%eax)
}
  801be5:	90                   	nop
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801beb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf7:	8b 00                	mov    (%eax),%eax
  801bf9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c00:	8b 45 10             	mov    0x10(%ebp),%eax
  801c03:	01 d0                	add    %edx,%eax
  801c05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c0b:	eb 0c                	jmp    801c19 <strsplit+0x31>
			*string++ = 0;
  801c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c10:	8d 50 01             	lea    0x1(%eax),%edx
  801c13:	89 55 08             	mov    %edx,0x8(%ebp)
  801c16:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	8a 00                	mov    (%eax),%al
  801c1e:	84 c0                	test   %al,%al
  801c20:	74 18                	je     801c3a <strsplit+0x52>
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	8a 00                	mov    (%eax),%al
  801c27:	0f be c0             	movsbl %al,%eax
  801c2a:	50                   	push   %eax
  801c2b:	ff 75 0c             	pushl  0xc(%ebp)
  801c2e:	e8 13 fb ff ff       	call   801746 <strchr>
  801c33:	83 c4 08             	add    $0x8,%esp
  801c36:	85 c0                	test   %eax,%eax
  801c38:	75 d3                	jne    801c0d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	8a 00                	mov    (%eax),%al
  801c3f:	84 c0                	test   %al,%al
  801c41:	74 5a                	je     801c9d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c43:	8b 45 14             	mov    0x14(%ebp),%eax
  801c46:	8b 00                	mov    (%eax),%eax
  801c48:	83 f8 0f             	cmp    $0xf,%eax
  801c4b:	75 07                	jne    801c54 <strsplit+0x6c>
		{
			return 0;
  801c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c52:	eb 66                	jmp    801cba <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c54:	8b 45 14             	mov    0x14(%ebp),%eax
  801c57:	8b 00                	mov    (%eax),%eax
  801c59:	8d 48 01             	lea    0x1(%eax),%ecx
  801c5c:	8b 55 14             	mov    0x14(%ebp),%edx
  801c5f:	89 0a                	mov    %ecx,(%edx)
  801c61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	01 c2                	add    %eax,%edx
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c72:	eb 03                	jmp    801c77 <strsplit+0x8f>
			string++;
  801c74:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	8a 00                	mov    (%eax),%al
  801c7c:	84 c0                	test   %al,%al
  801c7e:	74 8b                	je     801c0b <strsplit+0x23>
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	8a 00                	mov    (%eax),%al
  801c85:	0f be c0             	movsbl %al,%eax
  801c88:	50                   	push   %eax
  801c89:	ff 75 0c             	pushl  0xc(%ebp)
  801c8c:	e8 b5 fa ff ff       	call   801746 <strchr>
  801c91:	83 c4 08             	add    $0x8,%esp
  801c94:	85 c0                	test   %eax,%eax
  801c96:	74 dc                	je     801c74 <strsplit+0x8c>
			string++;
	}
  801c98:	e9 6e ff ff ff       	jmp    801c0b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c9d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca1:	8b 00                	mov    (%eax),%eax
  801ca3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801caa:	8b 45 10             	mov    0x10(%ebp),%eax
  801cad:	01 d0                	add    %edx,%eax
  801caf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cb5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  801cc2:	a1 28 40 80 00       	mov    0x804028,%eax
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	75 33                	jne    801cfe <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801ccb:	c7 05 20 41 80 00 00 	movl   $0x80000000,0x804120
  801cd2:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  801cd5:	c7 05 24 41 80 00 00 	movl   $0xa0000000,0x804124
  801cdc:	00 00 a0 
		spaces[0].pages = numPages;
  801cdf:	c7 05 28 41 80 00 00 	movl   $0x20000,0x804128
  801ce6:	00 02 00 
		spaces[0].isFree = 1;
  801ce9:	c7 05 2c 41 80 00 01 	movl   $0x1,0x80412c
  801cf0:	00 00 00 
		arraySize++;
  801cf3:	a1 28 40 80 00       	mov    0x804028,%eax
  801cf8:	40                   	inc    %eax
  801cf9:	a3 28 40 80 00       	mov    %eax,0x804028
	}
	int min_diff = numPages + 1;
  801cfe:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  801d05:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  801d0c:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801d13:	8b 55 08             	mov    0x8(%ebp),%edx
  801d16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d19:	01 d0                	add    %edx,%eax
  801d1b:	48                   	dec    %eax
  801d1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d22:	ba 00 00 00 00       	mov    $0x0,%edx
  801d27:	f7 75 e8             	divl   -0x18(%ebp)
  801d2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d2d:	29 d0                	sub    %edx,%eax
  801d2f:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  801d32:	8b 45 08             	mov    0x8(%ebp),%eax
  801d35:	c1 e8 0c             	shr    $0xc,%eax
  801d38:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  801d3b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801d42:	eb 57                	jmp    801d9b <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  801d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d47:	c1 e0 04             	shl    $0x4,%eax
  801d4a:	05 2c 41 80 00       	add    $0x80412c,%eax
  801d4f:	8b 00                	mov    (%eax),%eax
  801d51:	85 c0                	test   %eax,%eax
  801d53:	74 42                	je     801d97 <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  801d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d58:	c1 e0 04             	shl    $0x4,%eax
  801d5b:	05 28 41 80 00       	add    $0x804128,%eax
  801d60:	8b 00                	mov    (%eax),%eax
  801d62:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801d65:	7c 31                	jl     801d98 <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  801d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6a:	c1 e0 04             	shl    $0x4,%eax
  801d6d:	05 28 41 80 00       	add    $0x804128,%eax
  801d72:	8b 00                	mov    (%eax),%eax
  801d74:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801d77:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d7a:	7d 1c                	jge    801d98 <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  801d7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7f:	c1 e0 04             	shl    $0x4,%eax
  801d82:	05 28 41 80 00       	add    $0x804128,%eax
  801d87:	8b 00                	mov    (%eax),%eax
  801d89:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  801d8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d95:	eb 01                	jmp    801d98 <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801d97:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  801d98:	ff 45 ec             	incl   -0x14(%ebp)
  801d9b:	a1 28 40 80 00       	mov    0x804028,%eax
  801da0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801da3:	7c 9f                	jl     801d44 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  801da5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801da9:	75 0a                	jne    801db5 <malloc+0xf9>
	{
		return NULL;
  801dab:	b8 00 00 00 00       	mov    $0x0,%eax
  801db0:	e9 34 01 00 00       	jmp    801ee9 <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  801db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db8:	c1 e0 04             	shl    $0x4,%eax
  801dbb:	05 28 41 80 00       	add    $0x804128,%eax
  801dc0:	8b 00                	mov    (%eax),%eax
  801dc2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801dc5:	75 38                	jne    801dff <malloc+0x143>
		{
			spaces[index].isFree = 0;
  801dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dca:	c1 e0 04             	shl    $0x4,%eax
  801dcd:	05 2c 41 80 00       	add    $0x80412c,%eax
  801dd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  801dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ddb:	c1 e0 0c             	shl    $0xc,%eax
  801dde:	89 c2                	mov    %eax,%edx
  801de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de3:	c1 e0 04             	shl    $0x4,%eax
  801de6:	05 20 41 80 00       	add    $0x804120,%eax
  801deb:	8b 00                	mov    (%eax),%eax
  801ded:	83 ec 08             	sub    $0x8,%esp
  801df0:	52                   	push   %edx
  801df1:	50                   	push   %eax
  801df2:	e8 01 06 00 00       	call   8023f8 <sys_allocateMem>
  801df7:	83 c4 10             	add    $0x10,%esp
  801dfa:	e9 dd 00 00 00       	jmp    801edc <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  801dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e02:	c1 e0 04             	shl    $0x4,%eax
  801e05:	05 20 41 80 00       	add    $0x804120,%eax
  801e0a:	8b 00                	mov    (%eax),%eax
  801e0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e0f:	c1 e2 0c             	shl    $0xc,%edx
  801e12:	01 d0                	add    %edx,%eax
  801e14:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  801e17:	a1 28 40 80 00       	mov    0x804028,%eax
  801e1c:	c1 e0 04             	shl    $0x4,%eax
  801e1f:	8d 90 20 41 80 00    	lea    0x804120(%eax),%edx
  801e25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e28:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  801e2a:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e33:	c1 e0 04             	shl    $0x4,%eax
  801e36:	05 24 41 80 00       	add    $0x804124,%eax
  801e3b:	8b 00                	mov    (%eax),%eax
  801e3d:	c1 e2 04             	shl    $0x4,%edx
  801e40:	81 c2 24 41 80 00    	add    $0x804124,%edx
  801e46:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  801e48:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e51:	c1 e0 04             	shl    $0x4,%eax
  801e54:	05 28 41 80 00       	add    $0x804128,%eax
  801e59:	8b 00                	mov    (%eax),%eax
  801e5b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801e5e:	c1 e2 04             	shl    $0x4,%edx
  801e61:	81 c2 28 41 80 00    	add    $0x804128,%edx
  801e67:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  801e69:	a1 28 40 80 00       	mov    0x804028,%eax
  801e6e:	c1 e0 04             	shl    $0x4,%eax
  801e71:	05 2c 41 80 00       	add    $0x80412c,%eax
  801e76:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  801e7c:	a1 28 40 80 00       	mov    0x804028,%eax
  801e81:	40                   	inc    %eax
  801e82:	a3 28 40 80 00       	mov    %eax,0x804028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  801e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8a:	c1 e0 04             	shl    $0x4,%eax
  801e8d:	8d 90 24 41 80 00    	lea    0x804124(%eax),%edx
  801e93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e96:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  801e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9b:	c1 e0 04             	shl    $0x4,%eax
  801e9e:	8d 90 28 41 80 00    	lea    0x804128(%eax),%edx
  801ea4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea7:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  801ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eac:	c1 e0 04             	shl    $0x4,%eax
  801eaf:	05 2c 41 80 00       	add    $0x80412c,%eax
  801eb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
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
  801ed4:	e8 1f 05 00 00       	call   8023f8 <sys_allocateMem>
  801ed9:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  801edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edf:	c1 e0 04             	shl    $0x4,%eax
  801ee2:	05 20 41 80 00       	add    $0x804120,%eax
  801ee7:	8b 00                	mov    (%eax),%eax
	}


}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  801ef1:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  801ef8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801eff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801f06:	eb 3f                	jmp    801f47 <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  801f08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0b:	c1 e0 04             	shl    $0x4,%eax
  801f0e:	05 20 41 80 00       	add    $0x804120,%eax
  801f13:	8b 00                	mov    (%eax),%eax
  801f15:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f18:	75 2a                	jne    801f44 <free+0x59>
		{
			index=i;
  801f1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  801f20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f23:	c1 e0 04             	shl    $0x4,%eax
  801f26:	05 28 41 80 00       	add    $0x804128,%eax
  801f2b:	8b 00                	mov    (%eax),%eax
  801f2d:	c1 e0 0c             	shl    $0xc,%eax
  801f30:	89 c2                	mov    %eax,%edx
  801f32:	8b 45 08             	mov    0x8(%ebp),%eax
  801f35:	83 ec 08             	sub    $0x8,%esp
  801f38:	52                   	push   %edx
  801f39:	50                   	push   %eax
  801f3a:	e8 9d 04 00 00       	call   8023dc <sys_freeMem>
  801f3f:	83 c4 10             	add    $0x10,%esp
			break;
  801f42:	eb 0d                	jmp    801f51 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  801f44:	ff 45 ec             	incl   -0x14(%ebp)
  801f47:	a1 28 40 80 00       	mov    0x804028,%eax
  801f4c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801f4f:	7c b7                	jl     801f08 <free+0x1d>
			break;
		}

	}

	if(index == -1)
  801f51:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801f55:	75 17                	jne    801f6e <free+0x83>
	{
		panic("Error");
  801f57:	83 ec 04             	sub    $0x4,%esp
  801f5a:	68 10 35 80 00       	push   $0x803510
  801f5f:	68 81 00 00 00       	push   $0x81
  801f64:	68 16 35 80 00       	push   $0x803516
  801f69:	e8 22 ed ff ff       	call   800c90 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  801f6e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801f75:	e9 cc 00 00 00       	jmp    802046 <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  801f7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f7d:	c1 e0 04             	shl    $0x4,%eax
  801f80:	05 2c 41 80 00       	add    $0x80412c,%eax
  801f85:	8b 00                	mov    (%eax),%eax
  801f87:	85 c0                	test   %eax,%eax
  801f89:	0f 84 b3 00 00 00    	je     802042 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	c1 e0 04             	shl    $0x4,%eax
  801f95:	05 20 41 80 00       	add    $0x804120,%eax
  801f9a:	8b 10                	mov    (%eax),%edx
  801f9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f9f:	c1 e0 04             	shl    $0x4,%eax
  801fa2:	05 24 41 80 00       	add    $0x804124,%eax
  801fa7:	8b 00                	mov    (%eax),%eax
  801fa9:	39 c2                	cmp    %eax,%edx
  801fab:	0f 85 92 00 00 00    	jne    802043 <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb4:	c1 e0 04             	shl    $0x4,%eax
  801fb7:	05 24 41 80 00       	add    $0x804124,%eax
  801fbc:	8b 00                	mov    (%eax),%eax
  801fbe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fc1:	c1 e2 04             	shl    $0x4,%edx
  801fc4:	81 c2 24 41 80 00    	add    $0x804124,%edx
  801fca:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801fcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fcf:	c1 e0 04             	shl    $0x4,%eax
  801fd2:	05 28 41 80 00       	add    $0x804128,%eax
  801fd7:	8b 10                	mov    (%eax),%edx
  801fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdc:	c1 e0 04             	shl    $0x4,%eax
  801fdf:	05 28 41 80 00       	add    $0x804128,%eax
  801fe4:	8b 00                	mov    (%eax),%eax
  801fe6:	01 c2                	add    %eax,%edx
  801fe8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801feb:	c1 e0 04             	shl    $0x4,%eax
  801fee:	05 28 41 80 00       	add    $0x804128,%eax
  801ff3:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff8:	c1 e0 04             	shl    $0x4,%eax
  801ffb:	05 20 41 80 00       	add    $0x804120,%eax
  802000:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  802006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802009:	c1 e0 04             	shl    $0x4,%eax
  80200c:	05 24 41 80 00       	add    $0x804124,%eax
  802011:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  802017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201a:	c1 e0 04             	shl    $0x4,%eax
  80201d:	05 28 41 80 00       	add    $0x804128,%eax
  802022:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  802028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202b:	c1 e0 04             	shl    $0x4,%eax
  80202e:	05 2c 41 80 00       	add    $0x80412c,%eax
  802033:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  802039:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  802040:	eb 12                	jmp    802054 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  802042:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  802043:	ff 45 e8             	incl   -0x18(%ebp)
  802046:	a1 28 40 80 00       	mov    0x804028,%eax
  80204b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80204e:	0f 8c 26 ff ff ff    	jl     801f7a <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  802054:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80205b:	e9 cc 00 00 00       	jmp    80212c <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  802060:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802063:	c1 e0 04             	shl    $0x4,%eax
  802066:	05 2c 41 80 00       	add    $0x80412c,%eax
  80206b:	8b 00                	mov    (%eax),%eax
  80206d:	85 c0                	test   %eax,%eax
  80206f:	0f 84 b3 00 00 00    	je     802128 <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  802075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802078:	c1 e0 04             	shl    $0x4,%eax
  80207b:	05 24 41 80 00       	add    $0x804124,%eax
  802080:	8b 10                	mov    (%eax),%edx
  802082:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802085:	c1 e0 04             	shl    $0x4,%eax
  802088:	05 20 41 80 00       	add    $0x804120,%eax
  80208d:	8b 00                	mov    (%eax),%eax
  80208f:	39 c2                	cmp    %eax,%edx
  802091:	0f 85 92 00 00 00    	jne    802129 <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  802097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209a:	c1 e0 04             	shl    $0x4,%eax
  80209d:	05 20 41 80 00       	add    $0x804120,%eax
  8020a2:	8b 00                	mov    (%eax),%eax
  8020a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020a7:	c1 e2 04             	shl    $0x4,%edx
  8020aa:	81 c2 20 41 80 00    	add    $0x804120,%edx
  8020b0:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  8020b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020b5:	c1 e0 04             	shl    $0x4,%eax
  8020b8:	05 28 41 80 00       	add    $0x804128,%eax
  8020bd:	8b 10                	mov    (%eax),%edx
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	c1 e0 04             	shl    $0x4,%eax
  8020c5:	05 28 41 80 00       	add    $0x804128,%eax
  8020ca:	8b 00                	mov    (%eax),%eax
  8020cc:	01 c2                	add    %eax,%edx
  8020ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020d1:	c1 e0 04             	shl    $0x4,%eax
  8020d4:	05 28 41 80 00       	add    $0x804128,%eax
  8020d9:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  8020db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020de:	c1 e0 04             	shl    $0x4,%eax
  8020e1:	05 20 41 80 00       	add    $0x804120,%eax
  8020e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  8020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ef:	c1 e0 04             	shl    $0x4,%eax
  8020f2:	05 24 41 80 00       	add    $0x804124,%eax
  8020f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  8020fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802100:	c1 e0 04             	shl    $0x4,%eax
  802103:	05 28 41 80 00       	add    $0x804128,%eax
  802108:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  80210e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802111:	c1 e0 04             	shl    $0x4,%eax
  802114:	05 2c 41 80 00       	add    $0x80412c,%eax
  802119:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  80211f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  802126:	eb 12                	jmp    80213a <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  802128:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  802129:	ff 45 e4             	incl   -0x1c(%ebp)
  80212c:	a1 28 40 80 00       	mov    0x804028,%eax
  802131:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802134:	0f 8c 26 ff ff ff    	jl     802060 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  80213a:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80213e:	75 11                	jne    802151 <free+0x266>
	{
		spaces[index].isFree = 1;
  802140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802143:	c1 e0 04             	shl    $0x4,%eax
  802146:	05 2c 41 80 00       	add    $0x80412c,%eax
  80214b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  802151:	90                   	nop
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	83 ec 18             	sub    $0x18,%esp
  80215a:	8b 45 10             	mov    0x10(%ebp),%eax
  80215d:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  802160:	83 ec 04             	sub    $0x4,%esp
  802163:	68 24 35 80 00       	push   $0x803524
  802168:	68 b9 00 00 00       	push   $0xb9
  80216d:	68 16 35 80 00       	push   $0x803516
  802172:	e8 19 eb ff ff       	call   800c90 <_panic>

00802177 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80217d:	83 ec 04             	sub    $0x4,%esp
  802180:	68 24 35 80 00       	push   $0x803524
  802185:	68 bf 00 00 00       	push   $0xbf
  80218a:	68 16 35 80 00       	push   $0x803516
  80218f:	e8 fc ea ff ff       	call   800c90 <_panic>

00802194 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
  802197:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80219a:	83 ec 04             	sub    $0x4,%esp
  80219d:	68 24 35 80 00       	push   $0x803524
  8021a2:	68 c5 00 00 00       	push   $0xc5
  8021a7:	68 16 35 80 00       	push   $0x803516
  8021ac:	e8 df ea ff ff       	call   800c90 <_panic>

008021b1 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8021b7:	83 ec 04             	sub    $0x4,%esp
  8021ba:	68 24 35 80 00       	push   $0x803524
  8021bf:	68 ca 00 00 00       	push   $0xca
  8021c4:	68 16 35 80 00       	push   $0x803516
  8021c9:	e8 c2 ea ff ff       	call   800c90 <_panic>

008021ce <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8021d4:	83 ec 04             	sub    $0x4,%esp
  8021d7:	68 24 35 80 00       	push   $0x803524
  8021dc:	68 d0 00 00 00       	push   $0xd0
  8021e1:	68 16 35 80 00       	push   $0x803516
  8021e6:	e8 a5 ea ff ff       	call   800c90 <_panic>

008021eb <shrink>:
}
void shrink(uint32 newSize)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8021f1:	83 ec 04             	sub    $0x4,%esp
  8021f4:	68 24 35 80 00       	push   $0x803524
  8021f9:	68 d4 00 00 00       	push   $0xd4
  8021fe:	68 16 35 80 00       	push   $0x803516
  802203:	e8 88 ea ff ff       	call   800c90 <_panic>

00802208 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80220e:	83 ec 04             	sub    $0x4,%esp
  802211:	68 24 35 80 00       	push   $0x803524
  802216:	68 d9 00 00 00       	push   $0xd9
  80221b:	68 16 35 80 00       	push   $0x803516
  802220:	e8 6b ea ff ff       	call   800c90 <_panic>

00802225 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	57                   	push   %edi
  802229:	56                   	push   %esi
  80222a:	53                   	push   %ebx
  80222b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	8b 55 0c             	mov    0xc(%ebp),%edx
  802234:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802237:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80223a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80223d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802240:	cd 30                	int    $0x30
  802242:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802245:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802248:	83 c4 10             	add    $0x10,%esp
  80224b:	5b                   	pop    %ebx
  80224c:	5e                   	pop    %esi
  80224d:	5f                   	pop    %edi
  80224e:	5d                   	pop    %ebp
  80224f:	c3                   	ret    

00802250 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 04             	sub    $0x4,%esp
  802256:	8b 45 10             	mov    0x10(%ebp),%eax
  802259:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80225c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	52                   	push   %edx
  802268:	ff 75 0c             	pushl  0xc(%ebp)
  80226b:	50                   	push   %eax
  80226c:	6a 00                	push   $0x0
  80226e:	e8 b2 ff ff ff       	call   802225 <syscall>
  802273:	83 c4 18             	add    $0x18,%esp
}
  802276:	90                   	nop
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <sys_cgetc>:

int
sys_cgetc(void)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 01                	push   $0x1
  802288:	e8 98 ff ff ff       	call   802225 <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	50                   	push   %eax
  8022a1:	6a 05                	push   $0x5
  8022a3:	e8 7d ff ff ff       	call   802225 <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 02                	push   $0x2
  8022bc:	e8 64 ff ff ff       	call   802225 <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 03                	push   $0x3
  8022d5:	e8 4b ff ff ff       	call   802225 <syscall>
  8022da:	83 c4 18             	add    $0x18,%esp
}
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 04                	push   $0x4
  8022ee:	e8 32 ff ff ff       	call   802225 <syscall>
  8022f3:	83 c4 18             	add    $0x18,%esp
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <sys_env_exit>:


void sys_env_exit(void)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 06                	push   $0x6
  802307:	e8 19 ff ff ff       	call   802225 <syscall>
  80230c:	83 c4 18             	add    $0x18,%esp
}
  80230f:	90                   	nop
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802315:	8b 55 0c             	mov    0xc(%ebp),%edx
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	52                   	push   %edx
  802322:	50                   	push   %eax
  802323:	6a 07                	push   $0x7
  802325:	e8 fb fe ff ff       	call   802225 <syscall>
  80232a:	83 c4 18             	add    $0x18,%esp
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	56                   	push   %esi
  802333:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802334:	8b 75 18             	mov    0x18(%ebp),%esi
  802337:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80233a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80233d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	56                   	push   %esi
  802344:	53                   	push   %ebx
  802345:	51                   	push   %ecx
  802346:	52                   	push   %edx
  802347:	50                   	push   %eax
  802348:	6a 08                	push   $0x8
  80234a:	e8 d6 fe ff ff       	call   802225 <syscall>
  80234f:	83 c4 18             	add    $0x18,%esp
}
  802352:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802355:	5b                   	pop    %ebx
  802356:	5e                   	pop    %esi
  802357:	5d                   	pop    %ebp
  802358:	c3                   	ret    

00802359 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80235c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	52                   	push   %edx
  802369:	50                   	push   %eax
  80236a:	6a 09                	push   $0x9
  80236c:	e8 b4 fe ff ff       	call   802225 <syscall>
  802371:	83 c4 18             	add    $0x18,%esp
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	ff 75 0c             	pushl  0xc(%ebp)
  802382:	ff 75 08             	pushl  0x8(%ebp)
  802385:	6a 0a                	push   $0xa
  802387:	e8 99 fe ff ff       	call   802225 <syscall>
  80238c:	83 c4 18             	add    $0x18,%esp
}
  80238f:	c9                   	leave  
  802390:	c3                   	ret    

00802391 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 0b                	push   $0xb
  8023a0:	e8 80 fe ff ff       	call   802225 <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 0c                	push   $0xc
  8023b9:	e8 67 fe ff ff       	call   802225 <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
}
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 0d                	push   $0xd
  8023d2:	e8 4e fe ff ff       	call   802225 <syscall>
  8023d7:	83 c4 18             	add    $0x18,%esp
}
  8023da:	c9                   	leave  
  8023db:	c3                   	ret    

008023dc <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	ff 75 0c             	pushl  0xc(%ebp)
  8023e8:	ff 75 08             	pushl  0x8(%ebp)
  8023eb:	6a 11                	push   $0x11
  8023ed:	e8 33 fe ff ff       	call   802225 <syscall>
  8023f2:	83 c4 18             	add    $0x18,%esp
	return;
  8023f5:	90                   	nop
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	ff 75 0c             	pushl  0xc(%ebp)
  802404:	ff 75 08             	pushl  0x8(%ebp)
  802407:	6a 12                	push   $0x12
  802409:	e8 17 fe ff ff       	call   802225 <syscall>
  80240e:	83 c4 18             	add    $0x18,%esp
	return ;
  802411:	90                   	nop
}
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 0e                	push   $0xe
  802423:	e8 fd fd ff ff       	call   802225 <syscall>
  802428:	83 c4 18             	add    $0x18,%esp
}
  80242b:	c9                   	leave  
  80242c:	c3                   	ret    

0080242d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	ff 75 08             	pushl  0x8(%ebp)
  80243b:	6a 0f                	push   $0xf
  80243d:	e8 e3 fd ff ff       	call   802225 <syscall>
  802442:	83 c4 18             	add    $0x18,%esp
}
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 10                	push   $0x10
  802456:	e8 ca fd ff ff       	call   802225 <syscall>
  80245b:	83 c4 18             	add    $0x18,%esp
}
  80245e:	90                   	nop
  80245f:	c9                   	leave  
  802460:	c3                   	ret    

00802461 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 14                	push   $0x14
  802470:	e8 b0 fd ff ff       	call   802225 <syscall>
  802475:	83 c4 18             	add    $0x18,%esp
}
  802478:	90                   	nop
  802479:	c9                   	leave  
  80247a:	c3                   	ret    

0080247b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 15                	push   $0x15
  80248a:	e8 96 fd ff ff       	call   802225 <syscall>
  80248f:	83 c4 18             	add    $0x18,%esp
}
  802492:	90                   	nop
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <sys_cputc>:


void
sys_cputc(const char c)
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
  802498:	83 ec 04             	sub    $0x4,%esp
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8024a1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	50                   	push   %eax
  8024ae:	6a 16                	push   $0x16
  8024b0:	e8 70 fd ff ff       	call   802225 <syscall>
  8024b5:	83 c4 18             	add    $0x18,%esp
}
  8024b8:	90                   	nop
  8024b9:	c9                   	leave  
  8024ba:	c3                   	ret    

008024bb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 17                	push   $0x17
  8024ca:	e8 56 fd ff ff       	call   802225 <syscall>
  8024cf:	83 c4 18             	add    $0x18,%esp
}
  8024d2:	90                   	nop
  8024d3:	c9                   	leave  
  8024d4:	c3                   	ret    

008024d5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8024d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	ff 75 0c             	pushl  0xc(%ebp)
  8024e4:	50                   	push   %eax
  8024e5:	6a 18                	push   $0x18
  8024e7:	e8 39 fd ff ff       	call   802225 <syscall>
  8024ec:	83 c4 18             	add    $0x18,%esp
}
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	52                   	push   %edx
  802501:	50                   	push   %eax
  802502:	6a 1b                	push   $0x1b
  802504:	e8 1c fd ff ff       	call   802225 <syscall>
  802509:	83 c4 18             	add    $0x18,%esp
}
  80250c:	c9                   	leave  
  80250d:	c3                   	ret    

0080250e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802511:	8b 55 0c             	mov    0xc(%ebp),%edx
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	52                   	push   %edx
  80251e:	50                   	push   %eax
  80251f:	6a 19                	push   $0x19
  802521:	e8 ff fc ff ff       	call   802225 <syscall>
  802526:	83 c4 18             	add    $0x18,%esp
}
  802529:	90                   	nop
  80252a:	c9                   	leave  
  80252b:	c3                   	ret    

0080252c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80252f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802532:	8b 45 08             	mov    0x8(%ebp),%eax
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	52                   	push   %edx
  80253c:	50                   	push   %eax
  80253d:	6a 1a                	push   $0x1a
  80253f:	e8 e1 fc ff ff       	call   802225 <syscall>
  802544:	83 c4 18             	add    $0x18,%esp
}
  802547:	90                   	nop
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
  80254d:	83 ec 04             	sub    $0x4,%esp
  802550:	8b 45 10             	mov    0x10(%ebp),%eax
  802553:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802556:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802559:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80255d:	8b 45 08             	mov    0x8(%ebp),%eax
  802560:	6a 00                	push   $0x0
  802562:	51                   	push   %ecx
  802563:	52                   	push   %edx
  802564:	ff 75 0c             	pushl  0xc(%ebp)
  802567:	50                   	push   %eax
  802568:	6a 1c                	push   $0x1c
  80256a:	e8 b6 fc ff ff       	call   802225 <syscall>
  80256f:	83 c4 18             	add    $0x18,%esp
}
  802572:	c9                   	leave  
  802573:	c3                   	ret    

00802574 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802577:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	52                   	push   %edx
  802584:	50                   	push   %eax
  802585:	6a 1d                	push   $0x1d
  802587:	e8 99 fc ff ff       	call   802225 <syscall>
  80258c:	83 c4 18             	add    $0x18,%esp
}
  80258f:	c9                   	leave  
  802590:	c3                   	ret    

00802591 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802594:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802597:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	51                   	push   %ecx
  8025a2:	52                   	push   %edx
  8025a3:	50                   	push   %eax
  8025a4:	6a 1e                	push   $0x1e
  8025a6:	e8 7a fc ff ff       	call   802225 <syscall>
  8025ab:	83 c4 18             	add    $0x18,%esp
}
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8025b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	52                   	push   %edx
  8025c0:	50                   	push   %eax
  8025c1:	6a 1f                	push   $0x1f
  8025c3:	e8 5d fc ff ff       	call   802225 <syscall>
  8025c8:	83 c4 18             	add    $0x18,%esp
}
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    

008025cd <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8025cd:	55                   	push   %ebp
  8025ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 20                	push   $0x20
  8025dc:	e8 44 fc ff ff       	call   802225 <syscall>
  8025e1:	83 c4 18             	add    $0x18,%esp
}
  8025e4:	c9                   	leave  
  8025e5:	c3                   	ret    

008025e6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8025e6:	55                   	push   %ebp
  8025e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8025e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ec:	6a 00                	push   $0x0
  8025ee:	ff 75 14             	pushl  0x14(%ebp)
  8025f1:	ff 75 10             	pushl  0x10(%ebp)
  8025f4:	ff 75 0c             	pushl  0xc(%ebp)
  8025f7:	50                   	push   %eax
  8025f8:	6a 21                	push   $0x21
  8025fa:	e8 26 fc ff ff       	call   802225 <syscall>
  8025ff:	83 c4 18             	add    $0x18,%esp
}
  802602:	c9                   	leave  
  802603:	c3                   	ret    

00802604 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802604:	55                   	push   %ebp
  802605:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802607:	8b 45 08             	mov    0x8(%ebp),%eax
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	50                   	push   %eax
  802613:	6a 22                	push   $0x22
  802615:	e8 0b fc ff ff       	call   802225 <syscall>
  80261a:	83 c4 18             	add    $0x18,%esp
}
  80261d:	90                   	nop
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	50                   	push   %eax
  80262f:	6a 23                	push   $0x23
  802631:	e8 ef fb ff ff       	call   802225 <syscall>
  802636:	83 c4 18             	add    $0x18,%esp
}
  802639:	90                   	nop
  80263a:	c9                   	leave  
  80263b:	c3                   	ret    

0080263c <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
  80263f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802642:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802645:	8d 50 04             	lea    0x4(%eax),%edx
  802648:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80264b:	6a 00                	push   $0x0
  80264d:	6a 00                	push   $0x0
  80264f:	6a 00                	push   $0x0
  802651:	52                   	push   %edx
  802652:	50                   	push   %eax
  802653:	6a 24                	push   $0x24
  802655:	e8 cb fb ff ff       	call   802225 <syscall>
  80265a:	83 c4 18             	add    $0x18,%esp
	return result;
  80265d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802660:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802663:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802666:	89 01                	mov    %eax,(%ecx)
  802668:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80266b:	8b 45 08             	mov    0x8(%ebp),%eax
  80266e:	c9                   	leave  
  80266f:	c2 04 00             	ret    $0x4

00802672 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802672:	55                   	push   %ebp
  802673:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	ff 75 10             	pushl  0x10(%ebp)
  80267c:	ff 75 0c             	pushl  0xc(%ebp)
  80267f:	ff 75 08             	pushl  0x8(%ebp)
  802682:	6a 13                	push   $0x13
  802684:	e8 9c fb ff ff       	call   802225 <syscall>
  802689:	83 c4 18             	add    $0x18,%esp
	return ;
  80268c:	90                   	nop
}
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

0080268f <sys_rcr2>:
uint32 sys_rcr2()
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 25                	push   $0x25
  80269e:	e8 82 fb ff ff       	call   802225 <syscall>
  8026a3:	83 c4 18             	add    $0x18,%esp
}
  8026a6:	c9                   	leave  
  8026a7:	c3                   	ret    

008026a8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
  8026ab:	83 ec 04             	sub    $0x4,%esp
  8026ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026b4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 00                	push   $0x0
  8026c0:	50                   	push   %eax
  8026c1:	6a 26                	push   $0x26
  8026c3:	e8 5d fb ff ff       	call   802225 <syscall>
  8026c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8026cb:	90                   	nop
}
  8026cc:	c9                   	leave  
  8026cd:	c3                   	ret    

008026ce <rsttst>:
void rsttst()
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 28                	push   $0x28
  8026dd:	e8 43 fb ff ff       	call   802225 <syscall>
  8026e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8026e5:	90                   	nop
}
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
  8026eb:	83 ec 04             	sub    $0x4,%esp
  8026ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8026f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026f4:	8b 55 18             	mov    0x18(%ebp),%edx
  8026f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026fb:	52                   	push   %edx
  8026fc:	50                   	push   %eax
  8026fd:	ff 75 10             	pushl  0x10(%ebp)
  802700:	ff 75 0c             	pushl  0xc(%ebp)
  802703:	ff 75 08             	pushl  0x8(%ebp)
  802706:	6a 27                	push   $0x27
  802708:	e8 18 fb ff ff       	call   802225 <syscall>
  80270d:	83 c4 18             	add    $0x18,%esp
	return ;
  802710:	90                   	nop
}
  802711:	c9                   	leave  
  802712:	c3                   	ret    

00802713 <chktst>:
void chktst(uint32 n)
{
  802713:	55                   	push   %ebp
  802714:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	ff 75 08             	pushl  0x8(%ebp)
  802721:	6a 29                	push   $0x29
  802723:	e8 fd fa ff ff       	call   802225 <syscall>
  802728:	83 c4 18             	add    $0x18,%esp
	return ;
  80272b:	90                   	nop
}
  80272c:	c9                   	leave  
  80272d:	c3                   	ret    

0080272e <inctst>:

void inctst()
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802731:	6a 00                	push   $0x0
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 2a                	push   $0x2a
  80273d:	e8 e3 fa ff ff       	call   802225 <syscall>
  802742:	83 c4 18             	add    $0x18,%esp
	return ;
  802745:	90                   	nop
}
  802746:	c9                   	leave  
  802747:	c3                   	ret    

00802748 <gettst>:
uint32 gettst()
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80274b:	6a 00                	push   $0x0
  80274d:	6a 00                	push   $0x0
  80274f:	6a 00                	push   $0x0
  802751:	6a 00                	push   $0x0
  802753:	6a 00                	push   $0x0
  802755:	6a 2b                	push   $0x2b
  802757:	e8 c9 fa ff ff       	call   802225 <syscall>
  80275c:	83 c4 18             	add    $0x18,%esp
}
  80275f:	c9                   	leave  
  802760:	c3                   	ret    

00802761 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802761:	55                   	push   %ebp
  802762:	89 e5                	mov    %esp,%ebp
  802764:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	6a 2c                	push   $0x2c
  802773:	e8 ad fa ff ff       	call   802225 <syscall>
  802778:	83 c4 18             	add    $0x18,%esp
  80277b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80277e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802782:	75 07                	jne    80278b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802784:	b8 01 00 00 00       	mov    $0x1,%eax
  802789:	eb 05                	jmp    802790 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80278b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802790:	c9                   	leave  
  802791:	c3                   	ret    

00802792 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802792:	55                   	push   %ebp
  802793:	89 e5                	mov    %esp,%ebp
  802795:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 2c                	push   $0x2c
  8027a4:	e8 7c fa ff ff       	call   802225 <syscall>
  8027a9:	83 c4 18             	add    $0x18,%esp
  8027ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8027af:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8027b3:	75 07                	jne    8027bc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8027b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ba:	eb 05                	jmp    8027c1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8027bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027c1:	c9                   	leave  
  8027c2:	c3                   	ret    

008027c3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8027c3:	55                   	push   %ebp
  8027c4:	89 e5                	mov    %esp,%ebp
  8027c6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027c9:	6a 00                	push   $0x0
  8027cb:	6a 00                	push   $0x0
  8027cd:	6a 00                	push   $0x0
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 00                	push   $0x0
  8027d3:	6a 2c                	push   $0x2c
  8027d5:	e8 4b fa ff ff       	call   802225 <syscall>
  8027da:	83 c4 18             	add    $0x18,%esp
  8027dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8027e0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8027e4:	75 07                	jne    8027ed <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027eb:	eb 05                	jmp    8027f2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f2:	c9                   	leave  
  8027f3:	c3                   	ret    

008027f4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
  8027f7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027fa:	6a 00                	push   $0x0
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	6a 00                	push   $0x0
  802802:	6a 00                	push   $0x0
  802804:	6a 2c                	push   $0x2c
  802806:	e8 1a fa ff ff       	call   802225 <syscall>
  80280b:	83 c4 18             	add    $0x18,%esp
  80280e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802811:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802815:	75 07                	jne    80281e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802817:	b8 01 00 00 00       	mov    $0x1,%eax
  80281c:	eb 05                	jmp    802823 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80281e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	ff 75 08             	pushl  0x8(%ebp)
  802833:	6a 2d                	push   $0x2d
  802835:	e8 eb f9 ff ff       	call   802225 <syscall>
  80283a:	83 c4 18             	add    $0x18,%esp
	return ;
  80283d:	90                   	nop
}
  80283e:	c9                   	leave  
  80283f:	c3                   	ret    

00802840 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802840:	55                   	push   %ebp
  802841:	89 e5                	mov    %esp,%ebp
  802843:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802844:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802847:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80284a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80284d:	8b 45 08             	mov    0x8(%ebp),%eax
  802850:	6a 00                	push   $0x0
  802852:	53                   	push   %ebx
  802853:	51                   	push   %ecx
  802854:	52                   	push   %edx
  802855:	50                   	push   %eax
  802856:	6a 2e                	push   $0x2e
  802858:	e8 c8 f9 ff ff       	call   802225 <syscall>
  80285d:	83 c4 18             	add    $0x18,%esp
}
  802860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802863:	c9                   	leave  
  802864:	c3                   	ret    

00802865 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802865:	55                   	push   %ebp
  802866:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802868:	8b 55 0c             	mov    0xc(%ebp),%edx
  80286b:	8b 45 08             	mov    0x8(%ebp),%eax
  80286e:	6a 00                	push   $0x0
  802870:	6a 00                	push   $0x0
  802872:	6a 00                	push   $0x0
  802874:	52                   	push   %edx
  802875:	50                   	push   %eax
  802876:	6a 2f                	push   $0x2f
  802878:	e8 a8 f9 ff ff       	call   802225 <syscall>
  80287d:	83 c4 18             	add    $0x18,%esp
}
  802880:	c9                   	leave  
  802881:	c3                   	ret    

00802882 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802882:	55                   	push   %ebp
  802883:	89 e5                	mov    %esp,%ebp
  802885:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802888:	8b 55 08             	mov    0x8(%ebp),%edx
  80288b:	89 d0                	mov    %edx,%eax
  80288d:	c1 e0 02             	shl    $0x2,%eax
  802890:	01 d0                	add    %edx,%eax
  802892:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802899:	01 d0                	add    %edx,%eax
  80289b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028a2:	01 d0                	add    %edx,%eax
  8028a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028ab:	01 d0                	add    %edx,%eax
  8028ad:	c1 e0 04             	shl    $0x4,%eax
  8028b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8028b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8028ba:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8028bd:	83 ec 0c             	sub    $0xc,%esp
  8028c0:	50                   	push   %eax
  8028c1:	e8 76 fd ff ff       	call   80263c <sys_get_virtual_time>
  8028c6:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8028c9:	eb 41                	jmp    80290c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8028cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8028ce:	83 ec 0c             	sub    $0xc,%esp
  8028d1:	50                   	push   %eax
  8028d2:	e8 65 fd ff ff       	call   80263c <sys_get_virtual_time>
  8028d7:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8028da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e0:	29 c2                	sub    %eax,%edx
  8028e2:	89 d0                	mov    %edx,%eax
  8028e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8028e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ed:	89 d1                	mov    %edx,%ecx
  8028ef:	29 c1                	sub    %eax,%ecx
  8028f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8028f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f7:	39 c2                	cmp    %eax,%edx
  8028f9:	0f 97 c0             	seta   %al
  8028fc:	0f b6 c0             	movzbl %al,%eax
  8028ff:	29 c1                	sub    %eax,%ecx
  802901:	89 c8                	mov    %ecx,%eax
  802903:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802906:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802909:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802912:	72 b7                	jb     8028cb <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802914:	90                   	nop
  802915:	c9                   	leave  
  802916:	c3                   	ret    

00802917 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802917:	55                   	push   %ebp
  802918:	89 e5                	mov    %esp,%ebp
  80291a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80291d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802924:	eb 03                	jmp    802929 <busy_wait+0x12>
  802926:	ff 45 fc             	incl   -0x4(%ebp)
  802929:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80292c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292f:	72 f5                	jb     802926 <busy_wait+0xf>
	return i;
  802931:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802934:	c9                   	leave  
  802935:	c3                   	ret    
  802936:	66 90                	xchg   %ax,%ax

00802938 <__udivdi3>:
  802938:	55                   	push   %ebp
  802939:	57                   	push   %edi
  80293a:	56                   	push   %esi
  80293b:	53                   	push   %ebx
  80293c:	83 ec 1c             	sub    $0x1c,%esp
  80293f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802943:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802947:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80294b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80294f:	89 ca                	mov    %ecx,%edx
  802951:	89 f8                	mov    %edi,%eax
  802953:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802957:	85 f6                	test   %esi,%esi
  802959:	75 2d                	jne    802988 <__udivdi3+0x50>
  80295b:	39 cf                	cmp    %ecx,%edi
  80295d:	77 65                	ja     8029c4 <__udivdi3+0x8c>
  80295f:	89 fd                	mov    %edi,%ebp
  802961:	85 ff                	test   %edi,%edi
  802963:	75 0b                	jne    802970 <__udivdi3+0x38>
  802965:	b8 01 00 00 00       	mov    $0x1,%eax
  80296a:	31 d2                	xor    %edx,%edx
  80296c:	f7 f7                	div    %edi
  80296e:	89 c5                	mov    %eax,%ebp
  802970:	31 d2                	xor    %edx,%edx
  802972:	89 c8                	mov    %ecx,%eax
  802974:	f7 f5                	div    %ebp
  802976:	89 c1                	mov    %eax,%ecx
  802978:	89 d8                	mov    %ebx,%eax
  80297a:	f7 f5                	div    %ebp
  80297c:	89 cf                	mov    %ecx,%edi
  80297e:	89 fa                	mov    %edi,%edx
  802980:	83 c4 1c             	add    $0x1c,%esp
  802983:	5b                   	pop    %ebx
  802984:	5e                   	pop    %esi
  802985:	5f                   	pop    %edi
  802986:	5d                   	pop    %ebp
  802987:	c3                   	ret    
  802988:	39 ce                	cmp    %ecx,%esi
  80298a:	77 28                	ja     8029b4 <__udivdi3+0x7c>
  80298c:	0f bd fe             	bsr    %esi,%edi
  80298f:	83 f7 1f             	xor    $0x1f,%edi
  802992:	75 40                	jne    8029d4 <__udivdi3+0x9c>
  802994:	39 ce                	cmp    %ecx,%esi
  802996:	72 0a                	jb     8029a2 <__udivdi3+0x6a>
  802998:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80299c:	0f 87 9e 00 00 00    	ja     802a40 <__udivdi3+0x108>
  8029a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8029a7:	89 fa                	mov    %edi,%edx
  8029a9:	83 c4 1c             	add    $0x1c,%esp
  8029ac:	5b                   	pop    %ebx
  8029ad:	5e                   	pop    %esi
  8029ae:	5f                   	pop    %edi
  8029af:	5d                   	pop    %ebp
  8029b0:	c3                   	ret    
  8029b1:	8d 76 00             	lea    0x0(%esi),%esi
  8029b4:	31 ff                	xor    %edi,%edi
  8029b6:	31 c0                	xor    %eax,%eax
  8029b8:	89 fa                	mov    %edi,%edx
  8029ba:	83 c4 1c             	add    $0x1c,%esp
  8029bd:	5b                   	pop    %ebx
  8029be:	5e                   	pop    %esi
  8029bf:	5f                   	pop    %edi
  8029c0:	5d                   	pop    %ebp
  8029c1:	c3                   	ret    
  8029c2:	66 90                	xchg   %ax,%ax
  8029c4:	89 d8                	mov    %ebx,%eax
  8029c6:	f7 f7                	div    %edi
  8029c8:	31 ff                	xor    %edi,%edi
  8029ca:	89 fa                	mov    %edi,%edx
  8029cc:	83 c4 1c             	add    $0x1c,%esp
  8029cf:	5b                   	pop    %ebx
  8029d0:	5e                   	pop    %esi
  8029d1:	5f                   	pop    %edi
  8029d2:	5d                   	pop    %ebp
  8029d3:	c3                   	ret    
  8029d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8029d9:	89 eb                	mov    %ebp,%ebx
  8029db:	29 fb                	sub    %edi,%ebx
  8029dd:	89 f9                	mov    %edi,%ecx
  8029df:	d3 e6                	shl    %cl,%esi
  8029e1:	89 c5                	mov    %eax,%ebp
  8029e3:	88 d9                	mov    %bl,%cl
  8029e5:	d3 ed                	shr    %cl,%ebp
  8029e7:	89 e9                	mov    %ebp,%ecx
  8029e9:	09 f1                	or     %esi,%ecx
  8029eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8029ef:	89 f9                	mov    %edi,%ecx
  8029f1:	d3 e0                	shl    %cl,%eax
  8029f3:	89 c5                	mov    %eax,%ebp
  8029f5:	89 d6                	mov    %edx,%esi
  8029f7:	88 d9                	mov    %bl,%cl
  8029f9:	d3 ee                	shr    %cl,%esi
  8029fb:	89 f9                	mov    %edi,%ecx
  8029fd:	d3 e2                	shl    %cl,%edx
  8029ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a03:	88 d9                	mov    %bl,%cl
  802a05:	d3 e8                	shr    %cl,%eax
  802a07:	09 c2                	or     %eax,%edx
  802a09:	89 d0                	mov    %edx,%eax
  802a0b:	89 f2                	mov    %esi,%edx
  802a0d:	f7 74 24 0c          	divl   0xc(%esp)
  802a11:	89 d6                	mov    %edx,%esi
  802a13:	89 c3                	mov    %eax,%ebx
  802a15:	f7 e5                	mul    %ebp
  802a17:	39 d6                	cmp    %edx,%esi
  802a19:	72 19                	jb     802a34 <__udivdi3+0xfc>
  802a1b:	74 0b                	je     802a28 <__udivdi3+0xf0>
  802a1d:	89 d8                	mov    %ebx,%eax
  802a1f:	31 ff                	xor    %edi,%edi
  802a21:	e9 58 ff ff ff       	jmp    80297e <__udivdi3+0x46>
  802a26:	66 90                	xchg   %ax,%ax
  802a28:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a2c:	89 f9                	mov    %edi,%ecx
  802a2e:	d3 e2                	shl    %cl,%edx
  802a30:	39 c2                	cmp    %eax,%edx
  802a32:	73 e9                	jae    802a1d <__udivdi3+0xe5>
  802a34:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a37:	31 ff                	xor    %edi,%edi
  802a39:	e9 40 ff ff ff       	jmp    80297e <__udivdi3+0x46>
  802a3e:	66 90                	xchg   %ax,%ax
  802a40:	31 c0                	xor    %eax,%eax
  802a42:	e9 37 ff ff ff       	jmp    80297e <__udivdi3+0x46>
  802a47:	90                   	nop

00802a48 <__umoddi3>:
  802a48:	55                   	push   %ebp
  802a49:	57                   	push   %edi
  802a4a:	56                   	push   %esi
  802a4b:	53                   	push   %ebx
  802a4c:	83 ec 1c             	sub    $0x1c,%esp
  802a4f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802a53:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a67:	89 f3                	mov    %esi,%ebx
  802a69:	89 fa                	mov    %edi,%edx
  802a6b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a6f:	89 34 24             	mov    %esi,(%esp)
  802a72:	85 c0                	test   %eax,%eax
  802a74:	75 1a                	jne    802a90 <__umoddi3+0x48>
  802a76:	39 f7                	cmp    %esi,%edi
  802a78:	0f 86 a2 00 00 00    	jbe    802b20 <__umoddi3+0xd8>
  802a7e:	89 c8                	mov    %ecx,%eax
  802a80:	89 f2                	mov    %esi,%edx
  802a82:	f7 f7                	div    %edi
  802a84:	89 d0                	mov    %edx,%eax
  802a86:	31 d2                	xor    %edx,%edx
  802a88:	83 c4 1c             	add    $0x1c,%esp
  802a8b:	5b                   	pop    %ebx
  802a8c:	5e                   	pop    %esi
  802a8d:	5f                   	pop    %edi
  802a8e:	5d                   	pop    %ebp
  802a8f:	c3                   	ret    
  802a90:	39 f0                	cmp    %esi,%eax
  802a92:	0f 87 ac 00 00 00    	ja     802b44 <__umoddi3+0xfc>
  802a98:	0f bd e8             	bsr    %eax,%ebp
  802a9b:	83 f5 1f             	xor    $0x1f,%ebp
  802a9e:	0f 84 ac 00 00 00    	je     802b50 <__umoddi3+0x108>
  802aa4:	bf 20 00 00 00       	mov    $0x20,%edi
  802aa9:	29 ef                	sub    %ebp,%edi
  802aab:	89 fe                	mov    %edi,%esi
  802aad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ab1:	89 e9                	mov    %ebp,%ecx
  802ab3:	d3 e0                	shl    %cl,%eax
  802ab5:	89 d7                	mov    %edx,%edi
  802ab7:	89 f1                	mov    %esi,%ecx
  802ab9:	d3 ef                	shr    %cl,%edi
  802abb:	09 c7                	or     %eax,%edi
  802abd:	89 e9                	mov    %ebp,%ecx
  802abf:	d3 e2                	shl    %cl,%edx
  802ac1:	89 14 24             	mov    %edx,(%esp)
  802ac4:	89 d8                	mov    %ebx,%eax
  802ac6:	d3 e0                	shl    %cl,%eax
  802ac8:	89 c2                	mov    %eax,%edx
  802aca:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ace:	d3 e0                	shl    %cl,%eax
  802ad0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ad4:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ad8:	89 f1                	mov    %esi,%ecx
  802ada:	d3 e8                	shr    %cl,%eax
  802adc:	09 d0                	or     %edx,%eax
  802ade:	d3 eb                	shr    %cl,%ebx
  802ae0:	89 da                	mov    %ebx,%edx
  802ae2:	f7 f7                	div    %edi
  802ae4:	89 d3                	mov    %edx,%ebx
  802ae6:	f7 24 24             	mull   (%esp)
  802ae9:	89 c6                	mov    %eax,%esi
  802aeb:	89 d1                	mov    %edx,%ecx
  802aed:	39 d3                	cmp    %edx,%ebx
  802aef:	0f 82 87 00 00 00    	jb     802b7c <__umoddi3+0x134>
  802af5:	0f 84 91 00 00 00    	je     802b8c <__umoddi3+0x144>
  802afb:	8b 54 24 04          	mov    0x4(%esp),%edx
  802aff:	29 f2                	sub    %esi,%edx
  802b01:	19 cb                	sbb    %ecx,%ebx
  802b03:	89 d8                	mov    %ebx,%eax
  802b05:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802b09:	d3 e0                	shl    %cl,%eax
  802b0b:	89 e9                	mov    %ebp,%ecx
  802b0d:	d3 ea                	shr    %cl,%edx
  802b0f:	09 d0                	or     %edx,%eax
  802b11:	89 e9                	mov    %ebp,%ecx
  802b13:	d3 eb                	shr    %cl,%ebx
  802b15:	89 da                	mov    %ebx,%edx
  802b17:	83 c4 1c             	add    $0x1c,%esp
  802b1a:	5b                   	pop    %ebx
  802b1b:	5e                   	pop    %esi
  802b1c:	5f                   	pop    %edi
  802b1d:	5d                   	pop    %ebp
  802b1e:	c3                   	ret    
  802b1f:	90                   	nop
  802b20:	89 fd                	mov    %edi,%ebp
  802b22:	85 ff                	test   %edi,%edi
  802b24:	75 0b                	jne    802b31 <__umoddi3+0xe9>
  802b26:	b8 01 00 00 00       	mov    $0x1,%eax
  802b2b:	31 d2                	xor    %edx,%edx
  802b2d:	f7 f7                	div    %edi
  802b2f:	89 c5                	mov    %eax,%ebp
  802b31:	89 f0                	mov    %esi,%eax
  802b33:	31 d2                	xor    %edx,%edx
  802b35:	f7 f5                	div    %ebp
  802b37:	89 c8                	mov    %ecx,%eax
  802b39:	f7 f5                	div    %ebp
  802b3b:	89 d0                	mov    %edx,%eax
  802b3d:	e9 44 ff ff ff       	jmp    802a86 <__umoddi3+0x3e>
  802b42:	66 90                	xchg   %ax,%ax
  802b44:	89 c8                	mov    %ecx,%eax
  802b46:	89 f2                	mov    %esi,%edx
  802b48:	83 c4 1c             	add    $0x1c,%esp
  802b4b:	5b                   	pop    %ebx
  802b4c:	5e                   	pop    %esi
  802b4d:	5f                   	pop    %edi
  802b4e:	5d                   	pop    %ebp
  802b4f:	c3                   	ret    
  802b50:	3b 04 24             	cmp    (%esp),%eax
  802b53:	72 06                	jb     802b5b <__umoddi3+0x113>
  802b55:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802b59:	77 0f                	ja     802b6a <__umoddi3+0x122>
  802b5b:	89 f2                	mov    %esi,%edx
  802b5d:	29 f9                	sub    %edi,%ecx
  802b5f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802b63:	89 14 24             	mov    %edx,(%esp)
  802b66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b6a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b6e:	8b 14 24             	mov    (%esp),%edx
  802b71:	83 c4 1c             	add    $0x1c,%esp
  802b74:	5b                   	pop    %ebx
  802b75:	5e                   	pop    %esi
  802b76:	5f                   	pop    %edi
  802b77:	5d                   	pop    %ebp
  802b78:	c3                   	ret    
  802b79:	8d 76 00             	lea    0x0(%esi),%esi
  802b7c:	2b 04 24             	sub    (%esp),%eax
  802b7f:	19 fa                	sbb    %edi,%edx
  802b81:	89 d1                	mov    %edx,%ecx
  802b83:	89 c6                	mov    %eax,%esi
  802b85:	e9 71 ff ff ff       	jmp    802afb <__umoddi3+0xb3>
  802b8a:	66 90                	xchg   %ax,%ax
  802b8c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802b90:	72 ea                	jb     802b7c <__umoddi3+0x134>
  802b92:	89 d9                	mov    %ebx,%ecx
  802b94:	e9 62 ff ff ff       	jmp    802afb <__umoddi3+0xb3>
