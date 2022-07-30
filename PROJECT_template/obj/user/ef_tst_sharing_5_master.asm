
obj/user/ef_tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 37 04 00 00       	call   80046d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 23                	jmp    80006f <_main+0x37>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
  800051:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	c1 e2 04             	shl    $0x4,%edx
  80005d:	01 d0                	add    %edx,%eax
  80005f:	8a 40 04             	mov    0x4(%eax),%al
  800062:	84 c0                	test   %al,%al
  800064:	74 06                	je     80006c <_main+0x34>
			{
				fullWS = 0;
  800066:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006a:	eb 12                	jmp    80007e <_main+0x46>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006c:	ff 45 f0             	incl   -0x10(%ebp)
  80006f:	a1 20 30 80 00       	mov    0x803020,%eax
  800074:	8b 50 74             	mov    0x74(%eax),%edx
  800077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	77 ce                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80007e:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800082:	74 14                	je     800098 <_main+0x60>
  800084:	83 ec 04             	sub    $0x4,%esp
  800087:	68 c0 24 80 00       	push   $0x8024c0
  80008c:	6a 12                	push   $0x12
  80008e:	68 dc 24 80 00       	push   $0x8024dc
  800093:	e8 1a 05 00 00       	call   8005b2 <_panic>
	}

	cprintf("************************************************\n");
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	68 fc 24 80 00       	push   $0x8024fc
  8000a0:	e8 af 07 00 00       	call   800854 <cprintf>
  8000a5:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	68 30 25 80 00       	push   $0x802530
  8000b0:	e8 9f 07 00 00       	call   800854 <cprintf>
  8000b5:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	68 8c 25 80 00       	push   $0x80258c
  8000c0:	e8 8f 07 00 00       	call   800854 <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000c8:	e8 02 1b 00 00       	call   801bcf <sys_getenvid>
  8000cd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	68 c0 25 80 00       	push   $0x8025c0
  8000d8:	e8 77 07 00 00       	call   800854 <cprintf>
  8000dd:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		envIdSlave1 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e5:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  8000eb:	89 c2                	mov    %eax,%edx
  8000ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f2:	8b 40 74             	mov    0x74(%eax),%eax
  8000f5:	6a 32                	push   $0x32
  8000f7:	52                   	push   %edx
  8000f8:	50                   	push   %eax
  8000f9:	68 01 26 80 00       	push   $0x802601
  8000fe:	e8 05 1e 00 00       	call   801f08 <sys_create_env>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 45 e8             	mov    %eax,-0x18(%ebp)
		envIdSlave2 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800109:	a1 20 30 80 00       	mov    0x803020,%eax
  80010e:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  800114:	89 c2                	mov    %eax,%edx
  800116:	a1 20 30 80 00       	mov    0x803020,%eax
  80011b:	8b 40 74             	mov    0x74(%eax),%eax
  80011e:	6a 32                	push   $0x32
  800120:	52                   	push   %edx
  800121:	50                   	push   %eax
  800122:	68 01 26 80 00       	push   $0x802601
  800127:	e8 dc 1d 00 00       	call   801f08 <sys_create_env>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800132:	e8 7c 1b 00 00       	call   801cb3 <sys_calculate_free_frames>
  800137:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80013a:	83 ec 04             	sub    $0x4,%esp
  80013d:	6a 01                	push   $0x1
  80013f:	68 00 10 00 00       	push   $0x1000
  800144:	68 0f 26 80 00       	push   $0x80260f
  800149:	e8 28 19 00 00       	call   801a76 <smalloc>
  80014e:	83 c4 10             	add    $0x10,%esp
  800151:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	68 14 26 80 00       	push   $0x802614
  80015c:	e8 f3 06 00 00       	call   800854 <cprintf>
  800161:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800164:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80016b:	74 14                	je     800181 <_main+0x149>
  80016d:	83 ec 04             	sub    $0x4,%esp
  800170:	68 34 26 80 00       	push   $0x802634
  800175:	6a 26                	push   $0x26
  800177:	68 dc 24 80 00       	push   $0x8024dc
  80017c:	e8 31 04 00 00       	call   8005b2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800181:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800184:	e8 2a 1b 00 00       	call   801cb3 <sys_calculate_free_frames>
  800189:	29 c3                	sub    %eax,%ebx
  80018b:	89 d8                	mov    %ebx,%eax
  80018d:	83 f8 04             	cmp    $0x4,%eax
  800190:	74 14                	je     8001a6 <_main+0x16e>
  800192:	83 ec 04             	sub    $0x4,%esp
  800195:	68 a0 26 80 00       	push   $0x8026a0
  80019a:	6a 27                	push   $0x27
  80019c:	68 dc 24 80 00       	push   $0x8024dc
  8001a1:	e8 0c 04 00 00       	call   8005b2 <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001a6:	e8 45 1e 00 00       	call   801ff0 <rsttst>

		sys_run_env(envIdSlave1);
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b1:	e8 70 1d 00 00       	call   801f26 <sys_run_env>
  8001b6:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001bf:	e8 62 1d 00 00       	call   801f26 <sys_run_env>
  8001c4:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	68 1e 27 80 00       	push   $0x80271e
  8001cf:	e8 80 06 00 00       	call   800854 <cprintf>
  8001d4:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 b8 0b 00 00       	push   $0xbb8
  8001df:	e8 c0 1f 00 00       	call   8021a4 <env_sleep>
  8001e4:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001e7:	e8 7e 1e 00 00       	call   80206a <gettst>
  8001ec:	83 f8 02             	cmp    $0x2,%eax
  8001ef:	74 14                	je     800205 <_main+0x1cd>
  8001f1:	83 ec 04             	sub    $0x4,%esp
  8001f4:	68 35 27 80 00       	push   $0x802735
  8001f9:	6a 33                	push   $0x33
  8001fb:	68 dc 24 80 00       	push   $0x8024dc
  800200:	e8 ad 03 00 00       	call   8005b2 <_panic>

		sfree(x);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	ff 75 dc             	pushl  -0x24(%ebp)
  80020b:	e8 a6 18 00 00       	call   801ab6 <sfree>
  800210:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	68 44 27 80 00       	push   $0x802744
  80021b:	e8 34 06 00 00       	call   800854 <cprintf>
  800220:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800223:	e8 8b 1a 00 00       	call   801cb3 <sys_calculate_free_frames>
  800228:	89 c2                	mov    %eax,%edx
  80022a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022d:	29 c2                	sub    %eax,%edx
  80022f:	89 d0                	mov    %edx,%eax
  800231:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  800234:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800238:	74 14                	je     80024e <_main+0x216>
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	68 64 27 80 00       	push   $0x802764
  800242:	6a 38                	push   $0x38
  800244:	68 dc 24 80 00       	push   $0x8024dc
  800249:	e8 64 03 00 00       	call   8005b2 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  80024e:	83 ec 0c             	sub    $0xc,%esp
  800251:	68 94 27 80 00       	push   $0x802794
  800256:	e8 f9 05 00 00       	call   800854 <cprintf>
  80025b:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	68 b8 27 80 00       	push   $0x8027b8
  800266:	e8 e9 05 00 00       	call   800854 <cprintf>
  80026b:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		envIdSlaveB1 = sys_create_env("ef_tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80026e:	a1 20 30 80 00       	mov    0x803020,%eax
  800273:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  800279:	89 c2                	mov    %eax,%edx
  80027b:	a1 20 30 80 00       	mov    0x803020,%eax
  800280:	8b 40 74             	mov    0x74(%eax),%eax
  800283:	6a 32                	push   $0x32
  800285:	52                   	push   %edx
  800286:	50                   	push   %eax
  800287:	68 e8 27 80 00       	push   $0x8027e8
  80028c:	e8 77 1c 00 00       	call   801f08 <sys_create_env>
  800291:	83 c4 10             	add    $0x10,%esp
  800294:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		envIdSlaveB2 = sys_create_env("ef_tshr5slaveB2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),50);
  800297:	a1 20 30 80 00       	mov    0x803020,%eax
  80029c:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  8002a2:	89 c2                	mov    %eax,%edx
  8002a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a9:	8b 40 74             	mov    0x74(%eax),%eax
  8002ac:	6a 32                	push   $0x32
  8002ae:	52                   	push   %edx
  8002af:	50                   	push   %eax
  8002b0:	68 f8 27 80 00       	push   $0x8027f8
  8002b5:	e8 4e 1c 00 00       	call   801f08 <sys_create_env>
  8002ba:	83 c4 10             	add    $0x10,%esp
  8002bd:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002c0:	83 ec 04             	sub    $0x4,%esp
  8002c3:	6a 01                	push   $0x1
  8002c5:	68 00 10 00 00       	push   $0x1000
  8002ca:	68 08 28 80 00       	push   $0x802808
  8002cf:	e8 a2 17 00 00       	call   801a76 <smalloc>
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002da:	83 ec 0c             	sub    $0xc,%esp
  8002dd:	68 0c 28 80 00       	push   $0x80280c
  8002e2:	e8 6d 05 00 00       	call   800854 <cprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002ea:	83 ec 04             	sub    $0x4,%esp
  8002ed:	6a 01                	push   $0x1
  8002ef:	68 00 10 00 00       	push   $0x1000
  8002f4:	68 0f 26 80 00       	push   $0x80260f
  8002f9:	e8 78 17 00 00       	call   801a76 <smalloc>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 14 26 80 00       	push   $0x802614
  80030c:	e8 43 05 00 00       	call   800854 <cprintf>
  800311:	83 c4 10             	add    $0x10,%esp

		rsttst();
  800314:	e8 d7 1c 00 00       	call   801ff0 <rsttst>

		sys_run_env(envIdSlaveB1);
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80031f:	e8 02 1c 00 00       	call   801f26 <sys_run_env>
  800324:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	ff 75 d0             	pushl  -0x30(%ebp)
  80032d:	e8 f4 1b 00 00       	call   801f26 <sys_run_env>
  800332:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	68 a0 0f 00 00       	push   $0xfa0
  80033d:	e8 62 1e 00 00       	call   8021a4 <env_sleep>
  800342:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  800345:	e8 69 19 00 00       	call   801cb3 <sys_calculate_free_frames>
  80034a:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	ff 75 cc             	pushl  -0x34(%ebp)
  800353:	e8 5e 17 00 00       	call   801ab6 <sfree>
  800358:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  80035b:	83 ec 0c             	sub    $0xc,%esp
  80035e:	68 2c 28 80 00       	push   $0x80282c
  800363:	e8 ec 04 00 00       	call   800854 <cprintf>
  800368:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  80036b:	83 ec 0c             	sub    $0xc,%esp
  80036e:	ff 75 c8             	pushl  -0x38(%ebp)
  800371:	e8 40 17 00 00       	call   801ab6 <sfree>
  800376:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	68 42 28 80 00       	push   $0x802842
  800381:	e8 ce 04 00 00       	call   800854 <cprintf>
  800386:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  800389:	e8 25 19 00 00       	call   801cb3 <sys_calculate_free_frames>
  80038e:	89 c2                	mov    %eax,%edx
  800390:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800393:	29 c2                	sub    %eax,%edx
  800395:	89 d0                	mov    %edx,%eax
  800397:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  80039a:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  80039e:	74 14                	je     8003b4 <_main+0x37c>
  8003a0:	83 ec 04             	sub    $0x4,%esp
  8003a3:	68 58 28 80 00       	push   $0x802858
  8003a8:	6a 59                	push   $0x59
  8003aa:	68 dc 24 80 00       	push   $0x8024dc
  8003af:	e8 fe 01 00 00       	call   8005b2 <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003b4:	e8 97 1c 00 00       	call   802050 <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	6a 01                	push   $0x1
  8003be:	6a 04                	push   $0x4
  8003c0:	68 fd 28 80 00       	push   $0x8028fd
  8003c5:	e8 ac 16 00 00       	call   801a76 <smalloc>
  8003ca:	83 c4 10             	add    $0x10,%esp
  8003cd:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003d0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003d9:	e8 23 18 00 00       	call   801c01 <sys_getparentenvid>
  8003de:	85 c0                	test   %eax,%eax
  8003e0:	0f 8e 81 00 00 00    	jle    800467 <_main+0x42f>
			while(*finish_children != 1);
  8003e6:	90                   	nop
  8003e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ea:	8b 00                	mov    (%eax),%eax
  8003ec:	83 f8 01             	cmp    $0x1,%eax
  8003ef:	75 f6                	jne    8003e7 <_main+0x3af>
			cprintf("done\n");
  8003f1:	83 ec 0c             	sub    $0xc,%esp
  8003f4:	68 0d 29 80 00       	push   $0x80290d
  8003f9:	e8 56 04 00 00       	call   800854 <cprintf>
  8003fe:	83 c4 10             	add    $0x10,%esp
			sys_free_env(envIdSlave1);
  800401:	83 ec 0c             	sub    $0xc,%esp
  800404:	ff 75 e8             	pushl  -0x18(%ebp)
  800407:	e8 36 1b 00 00       	call   801f42 <sys_free_env>
  80040c:	83 c4 10             	add    $0x10,%esp
			sys_free_env(envIdSlave2);
  80040f:	83 ec 0c             	sub    $0xc,%esp
  800412:	ff 75 e4             	pushl  -0x1c(%ebp)
  800415:	e8 28 1b 00 00       	call   801f42 <sys_free_env>
  80041a:	83 c4 10             	add    $0x10,%esp
			sys_free_env(envIdSlaveB1);
  80041d:	83 ec 0c             	sub    $0xc,%esp
  800420:	ff 75 d4             	pushl  -0x2c(%ebp)
  800423:	e8 1a 1b 00 00       	call   801f42 <sys_free_env>
  800428:	83 c4 10             	add    $0x10,%esp
			sys_free_env(envIdSlaveB2);
  80042b:	83 ec 0c             	sub    $0xc,%esp
  80042e:	ff 75 d0             	pushl  -0x30(%ebp)
  800431:	e8 0c 1b 00 00       	call   801f42 <sys_free_env>
  800436:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  800439:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800440:	e8 bc 17 00 00       	call   801c01 <sys_getparentenvid>
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	68 13 29 80 00       	push   $0x802913
  80044d:	50                   	push   %eax
  80044e:	e8 46 16 00 00       	call   801a99 <sget>
  800453:	83 c4 10             	add    $0x10,%esp
  800456:	89 45 b8             	mov    %eax,-0x48(%ebp)
			(*finishedCount)++ ;
  800459:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80045c:	8b 00                	mov    (%eax),%eax
  80045e:	8d 50 01             	lea    0x1(%eax),%edx
  800461:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800464:	89 10                	mov    %edx,(%eax)
		}
	}


	return;
  800466:	90                   	nop
  800467:	90                   	nop
}
  800468:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80046b:	c9                   	leave  
  80046c:	c3                   	ret    

0080046d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80046d:	55                   	push   %ebp
  80046e:	89 e5                	mov    %esp,%ebp
  800470:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800473:	e8 70 17 00 00       	call   801be8 <sys_getenvindex>
  800478:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80047b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80047e:	89 d0                	mov    %edx,%eax
  800480:	c1 e0 03             	shl    $0x3,%eax
  800483:	01 d0                	add    %edx,%eax
  800485:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80048c:	01 c8                	add    %ecx,%eax
  80048e:	01 c0                	add    %eax,%eax
  800490:	01 d0                	add    %edx,%eax
  800492:	01 c0                	add    %eax,%eax
  800494:	01 d0                	add    %edx,%eax
  800496:	89 c2                	mov    %eax,%edx
  800498:	c1 e2 05             	shl    $0x5,%edx
  80049b:	29 c2                	sub    %eax,%edx
  80049d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8004a4:	89 c2                	mov    %eax,%edx
  8004a6:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8004ac:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b6:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8004bc:	84 c0                	test   %al,%al
  8004be:	74 0f                	je     8004cf <libmain+0x62>
		binaryname = myEnv->prog_name;
  8004c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c5:	05 40 3c 01 00       	add    $0x13c40,%eax
  8004ca:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004d3:	7e 0a                	jle    8004df <libmain+0x72>
		binaryname = argv[0];
  8004d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	ff 75 0c             	pushl  0xc(%ebp)
  8004e5:	ff 75 08             	pushl  0x8(%ebp)
  8004e8:	e8 4b fb ff ff       	call   800038 <_main>
  8004ed:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004f0:	e8 8e 18 00 00       	call   801d83 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004f5:	83 ec 0c             	sub    $0xc,%esp
  8004f8:	68 3c 29 80 00       	push   $0x80293c
  8004fd:	e8 52 03 00 00       	call   800854 <cprintf>
  800502:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800505:	a1 20 30 80 00       	mov    0x803020,%eax
  80050a:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800510:	a1 20 30 80 00       	mov    0x803020,%eax
  800515:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	52                   	push   %edx
  80051f:	50                   	push   %eax
  800520:	68 64 29 80 00       	push   $0x802964
  800525:	e8 2a 03 00 00       	call   800854 <cprintf>
  80052a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80052d:	a1 20 30 80 00       	mov    0x803020,%eax
  800532:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800538:	a1 20 30 80 00       	mov    0x803020,%eax
  80053d:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800543:	83 ec 04             	sub    $0x4,%esp
  800546:	52                   	push   %edx
  800547:	50                   	push   %eax
  800548:	68 8c 29 80 00       	push   $0x80298c
  80054d:	e8 02 03 00 00       	call   800854 <cprintf>
  800552:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800555:	a1 20 30 80 00       	mov    0x803020,%eax
  80055a:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	50                   	push   %eax
  800564:	68 cd 29 80 00       	push   $0x8029cd
  800569:	e8 e6 02 00 00       	call   800854 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800571:	83 ec 0c             	sub    $0xc,%esp
  800574:	68 3c 29 80 00       	push   $0x80293c
  800579:	e8 d6 02 00 00       	call   800854 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800581:	e8 17 18 00 00       	call   801d9d <sys_enable_interrupt>

	// exit gracefully
	exit();
  800586:	e8 19 00 00 00       	call   8005a4 <exit>
}
  80058b:	90                   	nop
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800594:	83 ec 0c             	sub    $0xc,%esp
  800597:	6a 00                	push   $0x0
  800599:	e8 16 16 00 00       	call   801bb4 <sys_env_destroy>
  80059e:	83 c4 10             	add    $0x10,%esp
}
  8005a1:	90                   	nop
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <exit>:

void
exit(void)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8005aa:	e8 6b 16 00 00       	call   801c1a <sys_env_exit>
}
  8005af:	90                   	nop
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005b8:	8d 45 10             	lea    0x10(%ebp),%eax
  8005bb:	83 c0 04             	add    $0x4,%eax
  8005be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005c1:	a1 18 31 80 00       	mov    0x803118,%eax
  8005c6:	85 c0                	test   %eax,%eax
  8005c8:	74 16                	je     8005e0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005ca:	a1 18 31 80 00       	mov    0x803118,%eax
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	50                   	push   %eax
  8005d3:	68 e4 29 80 00       	push   $0x8029e4
  8005d8:	e8 77 02 00 00       	call   800854 <cprintf>
  8005dd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005e0:	a1 00 30 80 00       	mov    0x803000,%eax
  8005e5:	ff 75 0c             	pushl  0xc(%ebp)
  8005e8:	ff 75 08             	pushl  0x8(%ebp)
  8005eb:	50                   	push   %eax
  8005ec:	68 e9 29 80 00       	push   $0x8029e9
  8005f1:	e8 5e 02 00 00       	call   800854 <cprintf>
  8005f6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005fc:	83 ec 08             	sub    $0x8,%esp
  8005ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800602:	50                   	push   %eax
  800603:	e8 e1 01 00 00       	call   8007e9 <vcprintf>
  800608:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	6a 00                	push   $0x0
  800610:	68 05 2a 80 00       	push   $0x802a05
  800615:	e8 cf 01 00 00       	call   8007e9 <vcprintf>
  80061a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80061d:	e8 82 ff ff ff       	call   8005a4 <exit>

	// should not return here
	while (1) ;
  800622:	eb fe                	jmp    800622 <_panic+0x70>

00800624 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800624:	55                   	push   %ebp
  800625:	89 e5                	mov    %esp,%ebp
  800627:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80062a:	a1 20 30 80 00       	mov    0x803020,%eax
  80062f:	8b 50 74             	mov    0x74(%eax),%edx
  800632:	8b 45 0c             	mov    0xc(%ebp),%eax
  800635:	39 c2                	cmp    %eax,%edx
  800637:	74 14                	je     80064d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800639:	83 ec 04             	sub    $0x4,%esp
  80063c:	68 08 2a 80 00       	push   $0x802a08
  800641:	6a 26                	push   $0x26
  800643:	68 54 2a 80 00       	push   $0x802a54
  800648:	e8 65 ff ff ff       	call   8005b2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80064d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800654:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80065b:	e9 b6 00 00 00       	jmp    800716 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800663:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	01 d0                	add    %edx,%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	85 c0                	test   %eax,%eax
  800673:	75 08                	jne    80067d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800675:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800678:	e9 96 00 00 00       	jmp    800713 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80067d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800684:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80068b:	eb 5d                	jmp    8006ea <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80068d:	a1 20 30 80 00       	mov    0x803020,%eax
  800692:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800698:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80069b:	c1 e2 04             	shl    $0x4,%edx
  80069e:	01 d0                	add    %edx,%eax
  8006a0:	8a 40 04             	mov    0x4(%eax),%al
  8006a3:	84 c0                	test   %al,%al
  8006a5:	75 40                	jne    8006e7 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8006ac:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8006b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b5:	c1 e2 04             	shl    $0x4,%edx
  8006b8:	01 d0                	add    %edx,%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006c7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	01 c8                	add    %ecx,%eax
  8006d8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006da:	39 c2                	cmp    %eax,%edx
  8006dc:	75 09                	jne    8006e7 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8006de:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006e5:	eb 12                	jmp    8006f9 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006e7:	ff 45 e8             	incl   -0x18(%ebp)
  8006ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8006ef:	8b 50 74             	mov    0x74(%eax),%edx
  8006f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006f5:	39 c2                	cmp    %eax,%edx
  8006f7:	77 94                	ja     80068d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006fd:	75 14                	jne    800713 <CheckWSWithoutLastIndex+0xef>
			panic(
  8006ff:	83 ec 04             	sub    $0x4,%esp
  800702:	68 60 2a 80 00       	push   $0x802a60
  800707:	6a 3a                	push   $0x3a
  800709:	68 54 2a 80 00       	push   $0x802a54
  80070e:	e8 9f fe ff ff       	call   8005b2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800713:	ff 45 f0             	incl   -0x10(%ebp)
  800716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800719:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80071c:	0f 8c 3e ff ff ff    	jl     800660 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800722:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800729:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800730:	eb 20                	jmp    800752 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800732:	a1 20 30 80 00       	mov    0x803020,%eax
  800737:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80073d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800740:	c1 e2 04             	shl    $0x4,%edx
  800743:	01 d0                	add    %edx,%eax
  800745:	8a 40 04             	mov    0x4(%eax),%al
  800748:	3c 01                	cmp    $0x1,%al
  80074a:	75 03                	jne    80074f <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80074c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80074f:	ff 45 e0             	incl   -0x20(%ebp)
  800752:	a1 20 30 80 00       	mov    0x803020,%eax
  800757:	8b 50 74             	mov    0x74(%eax),%edx
  80075a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80075d:	39 c2                	cmp    %eax,%edx
  80075f:	77 d1                	ja     800732 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800764:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800767:	74 14                	je     80077d <CheckWSWithoutLastIndex+0x159>
		panic(
  800769:	83 ec 04             	sub    $0x4,%esp
  80076c:	68 b4 2a 80 00       	push   $0x802ab4
  800771:	6a 44                	push   $0x44
  800773:	68 54 2a 80 00       	push   $0x802a54
  800778:	e8 35 fe ff ff       	call   8005b2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80077d:	90                   	nop
  80077e:	c9                   	leave  
  80077f:	c3                   	ret    

00800780 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800786:	8b 45 0c             	mov    0xc(%ebp),%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	8d 48 01             	lea    0x1(%eax),%ecx
  80078e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800791:	89 0a                	mov    %ecx,(%edx)
  800793:	8b 55 08             	mov    0x8(%ebp),%edx
  800796:	88 d1                	mov    %dl,%cl
  800798:	8b 55 0c             	mov    0xc(%ebp),%edx
  80079b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80079f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007a9:	75 2c                	jne    8007d7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007ab:	a0 24 30 80 00       	mov    0x803024,%al
  8007b0:	0f b6 c0             	movzbl %al,%eax
  8007b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b6:	8b 12                	mov    (%edx),%edx
  8007b8:	89 d1                	mov    %edx,%ecx
  8007ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bd:	83 c2 08             	add    $0x8,%edx
  8007c0:	83 ec 04             	sub    $0x4,%esp
  8007c3:	50                   	push   %eax
  8007c4:	51                   	push   %ecx
  8007c5:	52                   	push   %edx
  8007c6:	e8 a7 13 00 00       	call   801b72 <sys_cputs>
  8007cb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007da:	8b 40 04             	mov    0x4(%eax),%eax
  8007dd:	8d 50 01             	lea    0x1(%eax),%edx
  8007e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007e6:	90                   	nop
  8007e7:	c9                   	leave  
  8007e8:	c3                   	ret    

008007e9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007f2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007f9:	00 00 00 
	b.cnt = 0;
  8007fc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800803:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800806:	ff 75 0c             	pushl  0xc(%ebp)
  800809:	ff 75 08             	pushl  0x8(%ebp)
  80080c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800812:	50                   	push   %eax
  800813:	68 80 07 80 00       	push   $0x800780
  800818:	e8 11 02 00 00       	call   800a2e <vprintfmt>
  80081d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800820:	a0 24 30 80 00       	mov    0x803024,%al
  800825:	0f b6 c0             	movzbl %al,%eax
  800828:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80082e:	83 ec 04             	sub    $0x4,%esp
  800831:	50                   	push   %eax
  800832:	52                   	push   %edx
  800833:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800839:	83 c0 08             	add    $0x8,%eax
  80083c:	50                   	push   %eax
  80083d:	e8 30 13 00 00       	call   801b72 <sys_cputs>
  800842:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800845:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80084c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800852:	c9                   	leave  
  800853:	c3                   	ret    

00800854 <cprintf>:

int cprintf(const char *fmt, ...) {
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80085a:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800861:	8d 45 0c             	lea    0xc(%ebp),%eax
  800864:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 f4             	pushl  -0xc(%ebp)
  800870:	50                   	push   %eax
  800871:	e8 73 ff ff ff       	call   8007e9 <vcprintf>
  800876:	83 c4 10             	add    $0x10,%esp
  800879:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80087c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80087f:	c9                   	leave  
  800880:	c3                   	ret    

00800881 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800887:	e8 f7 14 00 00       	call   801d83 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80088c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80088f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	83 ec 08             	sub    $0x8,%esp
  800898:	ff 75 f4             	pushl  -0xc(%ebp)
  80089b:	50                   	push   %eax
  80089c:	e8 48 ff ff ff       	call   8007e9 <vcprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
  8008a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8008a7:	e8 f1 14 00 00       	call   801d9d <sys_enable_interrupt>
	return cnt;
  8008ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008af:	c9                   	leave  
  8008b0:	c3                   	ret    

008008b1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	53                   	push   %ebx
  8008b5:	83 ec 14             	sub    $0x14,%esp
  8008b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008be:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008c4:	8b 45 18             	mov    0x18(%ebp),%eax
  8008c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008cf:	77 55                	ja     800926 <printnum+0x75>
  8008d1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008d4:	72 05                	jb     8008db <printnum+0x2a>
  8008d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008d9:	77 4b                	ja     800926 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008db:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008de:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8008e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e9:	52                   	push   %edx
  8008ea:	50                   	push   %eax
  8008eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8008f1:	e8 62 19 00 00       	call   802258 <__udivdi3>
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	83 ec 04             	sub    $0x4,%esp
  8008fc:	ff 75 20             	pushl  0x20(%ebp)
  8008ff:	53                   	push   %ebx
  800900:	ff 75 18             	pushl  0x18(%ebp)
  800903:	52                   	push   %edx
  800904:	50                   	push   %eax
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	ff 75 08             	pushl  0x8(%ebp)
  80090b:	e8 a1 ff ff ff       	call   8008b1 <printnum>
  800910:	83 c4 20             	add    $0x20,%esp
  800913:	eb 1a                	jmp    80092f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800915:	83 ec 08             	sub    $0x8,%esp
  800918:	ff 75 0c             	pushl  0xc(%ebp)
  80091b:	ff 75 20             	pushl  0x20(%ebp)
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800926:	ff 4d 1c             	decl   0x1c(%ebp)
  800929:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80092d:	7f e6                	jg     800915 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80092f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800932:	bb 00 00 00 00       	mov    $0x0,%ebx
  800937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80093d:	53                   	push   %ebx
  80093e:	51                   	push   %ecx
  80093f:	52                   	push   %edx
  800940:	50                   	push   %eax
  800941:	e8 22 1a 00 00       	call   802368 <__umoddi3>
  800946:	83 c4 10             	add    $0x10,%esp
  800949:	05 14 2d 80 00       	add    $0x802d14,%eax
  80094e:	8a 00                	mov    (%eax),%al
  800950:	0f be c0             	movsbl %al,%eax
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	ff 75 0c             	pushl  0xc(%ebp)
  800959:	50                   	push   %eax
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	ff d0                	call   *%eax
  80095f:	83 c4 10             	add    $0x10,%esp
}
  800962:	90                   	nop
  800963:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800966:	c9                   	leave  
  800967:	c3                   	ret    

00800968 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80096b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80096f:	7e 1c                	jle    80098d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	8b 00                	mov    (%eax),%eax
  800976:	8d 50 08             	lea    0x8(%eax),%edx
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	89 10                	mov    %edx,(%eax)
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	8b 00                	mov    (%eax),%eax
  800983:	83 e8 08             	sub    $0x8,%eax
  800986:	8b 50 04             	mov    0x4(%eax),%edx
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	eb 40                	jmp    8009cd <getuint+0x65>
	else if (lflag)
  80098d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800991:	74 1e                	je     8009b1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8b 00                	mov    (%eax),%eax
  800998:	8d 50 04             	lea    0x4(%eax),%edx
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	89 10                	mov    %edx,(%eax)
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 00                	mov    (%eax),%eax
  8009a5:	83 e8 04             	sub    $0x4,%eax
  8009a8:	8b 00                	mov    (%eax),%eax
  8009aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8009af:	eb 1c                	jmp    8009cd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	8d 50 04             	lea    0x4(%eax),%edx
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	89 10                	mov    %edx,(%eax)
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	83 e8 04             	sub    $0x4,%eax
  8009c6:	8b 00                	mov    (%eax),%eax
  8009c8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009cd:	5d                   	pop    %ebp
  8009ce:	c3                   	ret    

008009cf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009d2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009d6:	7e 1c                	jle    8009f4 <getint+0x25>
		return va_arg(*ap, long long);
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	8d 50 08             	lea    0x8(%eax),%edx
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	89 10                	mov    %edx,(%eax)
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8b 00                	mov    (%eax),%eax
  8009ea:	83 e8 08             	sub    $0x8,%eax
  8009ed:	8b 50 04             	mov    0x4(%eax),%edx
  8009f0:	8b 00                	mov    (%eax),%eax
  8009f2:	eb 38                	jmp    800a2c <getint+0x5d>
	else if (lflag)
  8009f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009f8:	74 1a                	je     800a14 <getint+0x45>
		return va_arg(*ap, long);
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	8b 00                	mov    (%eax),%eax
  8009ff:	8d 50 04             	lea    0x4(%eax),%edx
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	89 10                	mov    %edx,(%eax)
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8b 00                	mov    (%eax),%eax
  800a0c:	83 e8 04             	sub    $0x4,%eax
  800a0f:	8b 00                	mov    (%eax),%eax
  800a11:	99                   	cltd   
  800a12:	eb 18                	jmp    800a2c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	8b 00                	mov    (%eax),%eax
  800a19:	8d 50 04             	lea    0x4(%eax),%edx
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	89 10                	mov    %edx,(%eax)
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	8b 00                	mov    (%eax),%eax
  800a26:	83 e8 04             	sub    $0x4,%eax
  800a29:	8b 00                	mov    (%eax),%eax
  800a2b:	99                   	cltd   
}
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    

00800a2e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	56                   	push   %esi
  800a32:	53                   	push   %ebx
  800a33:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a36:	eb 17                	jmp    800a4f <vprintfmt+0x21>
			if (ch == '\0')
  800a38:	85 db                	test   %ebx,%ebx
  800a3a:	0f 84 af 03 00 00    	je     800def <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	ff 75 0c             	pushl  0xc(%ebp)
  800a46:	53                   	push   %ebx
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	ff d0                	call   *%eax
  800a4c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a52:	8d 50 01             	lea    0x1(%eax),%edx
  800a55:	89 55 10             	mov    %edx,0x10(%ebp)
  800a58:	8a 00                	mov    (%eax),%al
  800a5a:	0f b6 d8             	movzbl %al,%ebx
  800a5d:	83 fb 25             	cmp    $0x25,%ebx
  800a60:	75 d6                	jne    800a38 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a62:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a66:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a6d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a7b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a82:	8b 45 10             	mov    0x10(%ebp),%eax
  800a85:	8d 50 01             	lea    0x1(%eax),%edx
  800a88:	89 55 10             	mov    %edx,0x10(%ebp)
  800a8b:	8a 00                	mov    (%eax),%al
  800a8d:	0f b6 d8             	movzbl %al,%ebx
  800a90:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a93:	83 f8 55             	cmp    $0x55,%eax
  800a96:	0f 87 2b 03 00 00    	ja     800dc7 <vprintfmt+0x399>
  800a9c:	8b 04 85 38 2d 80 00 	mov    0x802d38(,%eax,4),%eax
  800aa3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800aa5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800aa9:	eb d7                	jmp    800a82 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aab:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800aaf:	eb d1                	jmp    800a82 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ab1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ab8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800abb:	89 d0                	mov    %edx,%eax
  800abd:	c1 e0 02             	shl    $0x2,%eax
  800ac0:	01 d0                	add    %edx,%eax
  800ac2:	01 c0                	add    %eax,%eax
  800ac4:	01 d8                	add    %ebx,%eax
  800ac6:	83 e8 30             	sub    $0x30,%eax
  800ac9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800acc:	8b 45 10             	mov    0x10(%ebp),%eax
  800acf:	8a 00                	mov    (%eax),%al
  800ad1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ad4:	83 fb 2f             	cmp    $0x2f,%ebx
  800ad7:	7e 3e                	jle    800b17 <vprintfmt+0xe9>
  800ad9:	83 fb 39             	cmp    $0x39,%ebx
  800adc:	7f 39                	jg     800b17 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ade:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ae1:	eb d5                	jmp    800ab8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 c0 04             	add    $0x4,%eax
  800ae9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 e8 04             	sub    $0x4,%eax
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800af7:	eb 1f                	jmp    800b18 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800af9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800afd:	79 83                	jns    800a82 <vprintfmt+0x54>
				width = 0;
  800aff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b06:	e9 77 ff ff ff       	jmp    800a82 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b0b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b12:	e9 6b ff ff ff       	jmp    800a82 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b17:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b1c:	0f 89 60 ff ff ff    	jns    800a82 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b28:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b2f:	e9 4e ff ff ff       	jmp    800a82 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b34:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b37:	e9 46 ff ff ff       	jmp    800a82 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3f:	83 c0 04             	add    $0x4,%eax
  800b42:	89 45 14             	mov    %eax,0x14(%ebp)
  800b45:	8b 45 14             	mov    0x14(%ebp),%eax
  800b48:	83 e8 04             	sub    $0x4,%eax
  800b4b:	8b 00                	mov    (%eax),%eax
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	50                   	push   %eax
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	ff d0                	call   *%eax
  800b59:	83 c4 10             	add    $0x10,%esp
			break;
  800b5c:	e9 89 02 00 00       	jmp    800dea <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b61:	8b 45 14             	mov    0x14(%ebp),%eax
  800b64:	83 c0 04             	add    $0x4,%eax
  800b67:	89 45 14             	mov    %eax,0x14(%ebp)
  800b6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6d:	83 e8 04             	sub    $0x4,%eax
  800b70:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b72:	85 db                	test   %ebx,%ebx
  800b74:	79 02                	jns    800b78 <vprintfmt+0x14a>
				err = -err;
  800b76:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b78:	83 fb 64             	cmp    $0x64,%ebx
  800b7b:	7f 0b                	jg     800b88 <vprintfmt+0x15a>
  800b7d:	8b 34 9d 80 2b 80 00 	mov    0x802b80(,%ebx,4),%esi
  800b84:	85 f6                	test   %esi,%esi
  800b86:	75 19                	jne    800ba1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b88:	53                   	push   %ebx
  800b89:	68 25 2d 80 00       	push   $0x802d25
  800b8e:	ff 75 0c             	pushl  0xc(%ebp)
  800b91:	ff 75 08             	pushl  0x8(%ebp)
  800b94:	e8 5e 02 00 00       	call   800df7 <printfmt>
  800b99:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b9c:	e9 49 02 00 00       	jmp    800dea <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ba1:	56                   	push   %esi
  800ba2:	68 2e 2d 80 00       	push   $0x802d2e
  800ba7:	ff 75 0c             	pushl  0xc(%ebp)
  800baa:	ff 75 08             	pushl  0x8(%ebp)
  800bad:	e8 45 02 00 00       	call   800df7 <printfmt>
  800bb2:	83 c4 10             	add    $0x10,%esp
			break;
  800bb5:	e9 30 02 00 00       	jmp    800dea <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bba:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbd:	83 c0 04             	add    $0x4,%eax
  800bc0:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc6:	83 e8 04             	sub    $0x4,%eax
  800bc9:	8b 30                	mov    (%eax),%esi
  800bcb:	85 f6                	test   %esi,%esi
  800bcd:	75 05                	jne    800bd4 <vprintfmt+0x1a6>
				p = "(null)";
  800bcf:	be 31 2d 80 00       	mov    $0x802d31,%esi
			if (width > 0 && padc != '-')
  800bd4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd8:	7e 6d                	jle    800c47 <vprintfmt+0x219>
  800bda:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bde:	74 67                	je     800c47 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800be0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800be3:	83 ec 08             	sub    $0x8,%esp
  800be6:	50                   	push   %eax
  800be7:	56                   	push   %esi
  800be8:	e8 0c 03 00 00       	call   800ef9 <strnlen>
  800bed:	83 c4 10             	add    $0x10,%esp
  800bf0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bf3:	eb 16                	jmp    800c0b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bf5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	50                   	push   %eax
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c08:	ff 4d e4             	decl   -0x1c(%ebp)
  800c0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c0f:	7f e4                	jg     800bf5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c11:	eb 34                	jmp    800c47 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c13:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c17:	74 1c                	je     800c35 <vprintfmt+0x207>
  800c19:	83 fb 1f             	cmp    $0x1f,%ebx
  800c1c:	7e 05                	jle    800c23 <vprintfmt+0x1f5>
  800c1e:	83 fb 7e             	cmp    $0x7e,%ebx
  800c21:	7e 12                	jle    800c35 <vprintfmt+0x207>
					putch('?', putdat);
  800c23:	83 ec 08             	sub    $0x8,%esp
  800c26:	ff 75 0c             	pushl  0xc(%ebp)
  800c29:	6a 3f                	push   $0x3f
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	ff d0                	call   *%eax
  800c30:	83 c4 10             	add    $0x10,%esp
  800c33:	eb 0f                	jmp    800c44 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	53                   	push   %ebx
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	ff d0                	call   *%eax
  800c41:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c44:	ff 4d e4             	decl   -0x1c(%ebp)
  800c47:	89 f0                	mov    %esi,%eax
  800c49:	8d 70 01             	lea    0x1(%eax),%esi
  800c4c:	8a 00                	mov    (%eax),%al
  800c4e:	0f be d8             	movsbl %al,%ebx
  800c51:	85 db                	test   %ebx,%ebx
  800c53:	74 24                	je     800c79 <vprintfmt+0x24b>
  800c55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c59:	78 b8                	js     800c13 <vprintfmt+0x1e5>
  800c5b:	ff 4d e0             	decl   -0x20(%ebp)
  800c5e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c62:	79 af                	jns    800c13 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c64:	eb 13                	jmp    800c79 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c66:	83 ec 08             	sub    $0x8,%esp
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	6a 20                	push   $0x20
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	ff d0                	call   *%eax
  800c73:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c76:	ff 4d e4             	decl   -0x1c(%ebp)
  800c79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7d:	7f e7                	jg     800c66 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c7f:	e9 66 01 00 00       	jmp    800dea <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c84:	83 ec 08             	sub    $0x8,%esp
  800c87:	ff 75 e8             	pushl  -0x18(%ebp)
  800c8a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c8d:	50                   	push   %eax
  800c8e:	e8 3c fd ff ff       	call   8009cf <getint>
  800c93:	83 c4 10             	add    $0x10,%esp
  800c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca2:	85 d2                	test   %edx,%edx
  800ca4:	79 23                	jns    800cc9 <vprintfmt+0x29b>
				putch('-', putdat);
  800ca6:	83 ec 08             	sub    $0x8,%esp
  800ca9:	ff 75 0c             	pushl  0xc(%ebp)
  800cac:	6a 2d                	push   $0x2d
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	ff d0                	call   *%eax
  800cb3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cbc:	f7 d8                	neg    %eax
  800cbe:	83 d2 00             	adc    $0x0,%edx
  800cc1:	f7 da                	neg    %edx
  800cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cc9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cd0:	e9 bc 00 00 00       	jmp    800d91 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800cd5:	83 ec 08             	sub    $0x8,%esp
  800cd8:	ff 75 e8             	pushl  -0x18(%ebp)
  800cdb:	8d 45 14             	lea    0x14(%ebp),%eax
  800cde:	50                   	push   %eax
  800cdf:	e8 84 fc ff ff       	call   800968 <getuint>
  800ce4:	83 c4 10             	add    $0x10,%esp
  800ce7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ced:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cf4:	e9 98 00 00 00       	jmp    800d91 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cf9:	83 ec 08             	sub    $0x8,%esp
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	6a 58                	push   $0x58
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	ff d0                	call   *%eax
  800d06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d09:	83 ec 08             	sub    $0x8,%esp
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	6a 58                	push   $0x58
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	ff d0                	call   *%eax
  800d16:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	6a 58                	push   $0x58
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	ff d0                	call   *%eax
  800d26:	83 c4 10             	add    $0x10,%esp
			break;
  800d29:	e9 bc 00 00 00       	jmp    800dea <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d2e:	83 ec 08             	sub    $0x8,%esp
  800d31:	ff 75 0c             	pushl  0xc(%ebp)
  800d34:	6a 30                	push   $0x30
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	ff d0                	call   *%eax
  800d3b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	6a 78                	push   $0x78
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	ff d0                	call   *%eax
  800d4b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d51:	83 c0 04             	add    $0x4,%eax
  800d54:	89 45 14             	mov    %eax,0x14(%ebp)
  800d57:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5a:	83 e8 04             	sub    $0x4,%eax
  800d5d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d69:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d70:	eb 1f                	jmp    800d91 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	ff 75 e8             	pushl  -0x18(%ebp)
  800d78:	8d 45 14             	lea    0x14(%ebp),%eax
  800d7b:	50                   	push   %eax
  800d7c:	e8 e7 fb ff ff       	call   800968 <getuint>
  800d81:	83 c4 10             	add    $0x10,%esp
  800d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d87:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d8a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d91:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d98:	83 ec 04             	sub    $0x4,%esp
  800d9b:	52                   	push   %edx
  800d9c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d9f:	50                   	push   %eax
  800da0:	ff 75 f4             	pushl  -0xc(%ebp)
  800da3:	ff 75 f0             	pushl  -0x10(%ebp)
  800da6:	ff 75 0c             	pushl  0xc(%ebp)
  800da9:	ff 75 08             	pushl  0x8(%ebp)
  800dac:	e8 00 fb ff ff       	call   8008b1 <printnum>
  800db1:	83 c4 20             	add    $0x20,%esp
			break;
  800db4:	eb 34                	jmp    800dea <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800db6:	83 ec 08             	sub    $0x8,%esp
  800db9:	ff 75 0c             	pushl  0xc(%ebp)
  800dbc:	53                   	push   %ebx
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	ff d0                	call   *%eax
  800dc2:	83 c4 10             	add    $0x10,%esp
			break;
  800dc5:	eb 23                	jmp    800dea <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dc7:	83 ec 08             	sub    $0x8,%esp
  800dca:	ff 75 0c             	pushl  0xc(%ebp)
  800dcd:	6a 25                	push   $0x25
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	ff d0                	call   *%eax
  800dd4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dd7:	ff 4d 10             	decl   0x10(%ebp)
  800dda:	eb 03                	jmp    800ddf <vprintfmt+0x3b1>
  800ddc:	ff 4d 10             	decl   0x10(%ebp)
  800ddf:	8b 45 10             	mov    0x10(%ebp),%eax
  800de2:	48                   	dec    %eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	3c 25                	cmp    $0x25,%al
  800de7:	75 f3                	jne    800ddc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800de9:	90                   	nop
		}
	}
  800dea:	e9 47 fc ff ff       	jmp    800a36 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800def:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800df0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800df3:	5b                   	pop    %ebx
  800df4:	5e                   	pop    %esi
  800df5:	5d                   	pop    %ebp
  800df6:	c3                   	ret    

00800df7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800dfd:	8d 45 10             	lea    0x10(%ebp),%eax
  800e00:	83 c0 04             	add    $0x4,%eax
  800e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e06:	8b 45 10             	mov    0x10(%ebp),%eax
  800e09:	ff 75 f4             	pushl  -0xc(%ebp)
  800e0c:	50                   	push   %eax
  800e0d:	ff 75 0c             	pushl  0xc(%ebp)
  800e10:	ff 75 08             	pushl  0x8(%ebp)
  800e13:	e8 16 fc ff ff       	call   800a2e <vprintfmt>
  800e18:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e1b:	90                   	nop
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e24:	8b 40 08             	mov    0x8(%eax),%eax
  800e27:	8d 50 01             	lea    0x1(%eax),%edx
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	8b 10                	mov    (%eax),%edx
  800e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e38:	8b 40 04             	mov    0x4(%eax),%eax
  800e3b:	39 c2                	cmp    %eax,%edx
  800e3d:	73 12                	jae    800e51 <sprintputch+0x33>
		*b->buf++ = ch;
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	8b 00                	mov    (%eax),%eax
  800e44:	8d 48 01             	lea    0x1(%eax),%ecx
  800e47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4a:	89 0a                	mov    %ecx,(%edx)
  800e4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4f:	88 10                	mov    %dl,(%eax)
}
  800e51:	90                   	nop
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    

00800e54 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	01 d0                	add    %edx,%eax
  800e6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e79:	74 06                	je     800e81 <vsnprintf+0x2d>
  800e7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7f:	7f 07                	jg     800e88 <vsnprintf+0x34>
		return -E_INVAL;
  800e81:	b8 03 00 00 00       	mov    $0x3,%eax
  800e86:	eb 20                	jmp    800ea8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e88:	ff 75 14             	pushl  0x14(%ebp)
  800e8b:	ff 75 10             	pushl  0x10(%ebp)
  800e8e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e91:	50                   	push   %eax
  800e92:	68 1e 0e 80 00       	push   $0x800e1e
  800e97:	e8 92 fb ff ff       	call   800a2e <vprintfmt>
  800e9c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ea2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800eb0:	8d 45 10             	lea    0x10(%ebp),%eax
  800eb3:	83 c0 04             	add    $0x4,%eax
  800eb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebc:	ff 75 f4             	pushl  -0xc(%ebp)
  800ebf:	50                   	push   %eax
  800ec0:	ff 75 0c             	pushl  0xc(%ebp)
  800ec3:	ff 75 08             	pushl  0x8(%ebp)
  800ec6:	e8 89 ff ff ff       	call   800e54 <vsnprintf>
  800ecb:	83 c4 10             	add    $0x10,%esp
  800ece:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ed4:	c9                   	leave  
  800ed5:	c3                   	ret    

00800ed6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800edc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ee3:	eb 06                	jmp    800eeb <strlen+0x15>
		n++;
  800ee5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ee8:	ff 45 08             	incl   0x8(%ebp)
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	84 c0                	test   %al,%al
  800ef2:	75 f1                	jne    800ee5 <strlen+0xf>
		n++;
	return n;
  800ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ef7:	c9                   	leave  
  800ef8:	c3                   	ret    

00800ef9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f06:	eb 09                	jmp    800f11 <strnlen+0x18>
		n++;
  800f08:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0b:	ff 45 08             	incl   0x8(%ebp)
  800f0e:	ff 4d 0c             	decl   0xc(%ebp)
  800f11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f15:	74 09                	je     800f20 <strnlen+0x27>
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	84 c0                	test   %al,%al
  800f1e:	75 e8                	jne    800f08 <strnlen+0xf>
		n++;
	return n;
  800f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f31:	90                   	nop
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8d 50 01             	lea    0x1(%eax),%edx
  800f38:	89 55 08             	mov    %edx,0x8(%ebp)
  800f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f41:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f44:	8a 12                	mov    (%edx),%dl
  800f46:	88 10                	mov    %dl,(%eax)
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	84 c0                	test   %al,%al
  800f4c:	75 e4                	jne    800f32 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f5f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f66:	eb 1f                	jmp    800f87 <strncpy+0x34>
		*dst++ = *src;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8d 50 01             	lea    0x1(%eax),%edx
  800f6e:	89 55 08             	mov    %edx,0x8(%ebp)
  800f71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f74:	8a 12                	mov    (%edx),%dl
  800f76:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7b:	8a 00                	mov    (%eax),%al
  800f7d:	84 c0                	test   %al,%al
  800f7f:	74 03                	je     800f84 <strncpy+0x31>
			src++;
  800f81:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f84:	ff 45 fc             	incl   -0x4(%ebp)
  800f87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f8d:	72 d9                	jb     800f68 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f92:	c9                   	leave  
  800f93:	c3                   	ret    

00800f94 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa4:	74 30                	je     800fd6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fa6:	eb 16                	jmp    800fbe <strlcpy+0x2a>
			*dst++ = *src++;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8d 50 01             	lea    0x1(%eax),%edx
  800fae:	89 55 08             	mov    %edx,0x8(%ebp)
  800fb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fb7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fba:	8a 12                	mov    (%edx),%dl
  800fbc:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fbe:	ff 4d 10             	decl   0x10(%ebp)
  800fc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc5:	74 09                	je     800fd0 <strlcpy+0x3c>
  800fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	84 c0                	test   %al,%al
  800fce:	75 d8                	jne    800fa8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdc:	29 c2                	sub    %eax,%edx
  800fde:	89 d0                	mov    %edx,%eax
}
  800fe0:	c9                   	leave  
  800fe1:	c3                   	ret    

00800fe2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fe5:	eb 06                	jmp    800fed <strcmp+0xb>
		p++, q++;
  800fe7:	ff 45 08             	incl   0x8(%ebp)
  800fea:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	84 c0                	test   %al,%al
  800ff4:	74 0e                	je     801004 <strcmp+0x22>
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 10                	mov    (%eax),%dl
  800ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	38 c2                	cmp    %al,%dl
  801002:	74 e3                	je     800fe7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	0f b6 d0             	movzbl %al,%edx
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	0f b6 c0             	movzbl %al,%eax
  801014:	29 c2                	sub    %eax,%edx
  801016:	89 d0                	mov    %edx,%eax
}
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80101d:	eb 09                	jmp    801028 <strncmp+0xe>
		n--, p++, q++;
  80101f:	ff 4d 10             	decl   0x10(%ebp)
  801022:	ff 45 08             	incl   0x8(%ebp)
  801025:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801028:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80102c:	74 17                	je     801045 <strncmp+0x2b>
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	84 c0                	test   %al,%al
  801035:	74 0e                	je     801045 <strncmp+0x2b>
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 10                	mov    (%eax),%dl
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	8a 00                	mov    (%eax),%al
  801041:	38 c2                	cmp    %al,%dl
  801043:	74 da                	je     80101f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801045:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801049:	75 07                	jne    801052 <strncmp+0x38>
		return 0;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
  801050:	eb 14                	jmp    801066 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	8a 00                	mov    (%eax),%al
  801057:	0f b6 d0             	movzbl %al,%edx
  80105a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	0f b6 c0             	movzbl %al,%eax
  801062:	29 c2                	sub    %eax,%edx
  801064:	89 d0                	mov    %edx,%eax
}
  801066:	5d                   	pop    %ebp
  801067:	c3                   	ret    

00801068 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 04             	sub    $0x4,%esp
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801074:	eb 12                	jmp    801088 <strchr+0x20>
		if (*s == c)
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80107e:	75 05                	jne    801085 <strchr+0x1d>
			return (char *) s;
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	eb 11                	jmp    801096 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801085:	ff 45 08             	incl   0x8(%ebp)
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	84 c0                	test   %al,%al
  80108f:	75 e5                	jne    801076 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801091:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801096:	c9                   	leave  
  801097:	c3                   	ret    

00801098 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	83 ec 04             	sub    $0x4,%esp
  80109e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010a4:	eb 0d                	jmp    8010b3 <strfind+0x1b>
		if (*s == c)
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	8a 00                	mov    (%eax),%al
  8010ab:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010ae:	74 0e                	je     8010be <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010b0:	ff 45 08             	incl   0x8(%ebp)
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	84 c0                	test   %al,%al
  8010ba:	75 ea                	jne    8010a6 <strfind+0xe>
  8010bc:	eb 01                	jmp    8010bf <strfind+0x27>
		if (*s == c)
			break;
  8010be:	90                   	nop
	return (char *) s;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c2:	c9                   	leave  
  8010c3:	c3                   	ret    

008010c4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010d6:	eb 0e                	jmp    8010e6 <memset+0x22>
		*p++ = c;
  8010d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010db:	8d 50 01             	lea    0x1(%eax),%edx
  8010de:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010e6:	ff 4d f8             	decl   -0x8(%ebp)
  8010e9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010ed:	79 e9                	jns    8010d8 <memset+0x14>
		*p++ = c;

	return v;
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801106:	eb 16                	jmp    80111e <memcpy+0x2a>
		*d++ = *s++;
  801108:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110b:	8d 50 01             	lea    0x1(%eax),%edx
  80110e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801111:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801114:	8d 4a 01             	lea    0x1(%edx),%ecx
  801117:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80111a:	8a 12                	mov    (%edx),%dl
  80111c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80111e:	8b 45 10             	mov    0x10(%ebp),%eax
  801121:	8d 50 ff             	lea    -0x1(%eax),%edx
  801124:	89 55 10             	mov    %edx,0x10(%ebp)
  801127:	85 c0                	test   %eax,%eax
  801129:	75 dd                	jne    801108 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801136:	8b 45 0c             	mov    0xc(%ebp),%eax
  801139:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801142:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801145:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801148:	73 50                	jae    80119a <memmove+0x6a>
  80114a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114d:	8b 45 10             	mov    0x10(%ebp),%eax
  801150:	01 d0                	add    %edx,%eax
  801152:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801155:	76 43                	jbe    80119a <memmove+0x6a>
		s += n;
  801157:	8b 45 10             	mov    0x10(%ebp),%eax
  80115a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80115d:	8b 45 10             	mov    0x10(%ebp),%eax
  801160:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801163:	eb 10                	jmp    801175 <memmove+0x45>
			*--d = *--s;
  801165:	ff 4d f8             	decl   -0x8(%ebp)
  801168:	ff 4d fc             	decl   -0x4(%ebp)
  80116b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116e:	8a 10                	mov    (%eax),%dl
  801170:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801173:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801175:	8b 45 10             	mov    0x10(%ebp),%eax
  801178:	8d 50 ff             	lea    -0x1(%eax),%edx
  80117b:	89 55 10             	mov    %edx,0x10(%ebp)
  80117e:	85 c0                	test   %eax,%eax
  801180:	75 e3                	jne    801165 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801182:	eb 23                	jmp    8011a7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801184:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801187:	8d 50 01             	lea    0x1(%eax),%edx
  80118a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801190:	8d 4a 01             	lea    0x1(%edx),%ecx
  801193:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801196:	8a 12                	mov    (%edx),%dl
  801198:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80119a:	8b 45 10             	mov    0x10(%ebp),%eax
  80119d:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a0:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a3:	85 c0                	test   %eax,%eax
  8011a5:	75 dd                	jne    801184 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011aa:	c9                   	leave  
  8011ab:	c3                   	ret    

008011ac <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011be:	eb 2a                	jmp    8011ea <memcmp+0x3e>
		if (*s1 != *s2)
  8011c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c3:	8a 10                	mov    (%eax),%dl
  8011c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	38 c2                	cmp    %al,%dl
  8011cc:	74 16                	je     8011e4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	0f b6 d0             	movzbl %al,%edx
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	0f b6 c0             	movzbl %al,%eax
  8011de:	29 c2                	sub    %eax,%edx
  8011e0:	89 d0                	mov    %edx,%eax
  8011e2:	eb 18                	jmp    8011fc <memcmp+0x50>
		s1++, s2++;
  8011e4:	ff 45 fc             	incl   -0x4(%ebp)
  8011e7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	75 c9                	jne    8011c0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    

008011fe <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801204:	8b 55 08             	mov    0x8(%ebp),%edx
  801207:	8b 45 10             	mov    0x10(%ebp),%eax
  80120a:	01 d0                	add    %edx,%eax
  80120c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80120f:	eb 15                	jmp    801226 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	0f b6 d0             	movzbl %al,%edx
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	0f b6 c0             	movzbl %al,%eax
  80121f:	39 c2                	cmp    %eax,%edx
  801221:	74 0d                	je     801230 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801223:	ff 45 08             	incl   0x8(%ebp)
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80122c:	72 e3                	jb     801211 <memfind+0x13>
  80122e:	eb 01                	jmp    801231 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801230:	90                   	nop
	return (void *) s;
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80123c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801243:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80124a:	eb 03                	jmp    80124f <strtol+0x19>
		s++;
  80124c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	3c 20                	cmp    $0x20,%al
  801256:	74 f4                	je     80124c <strtol+0x16>
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	3c 09                	cmp    $0x9,%al
  80125f:	74 eb                	je     80124c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	3c 2b                	cmp    $0x2b,%al
  801268:	75 05                	jne    80126f <strtol+0x39>
		s++;
  80126a:	ff 45 08             	incl   0x8(%ebp)
  80126d:	eb 13                	jmp    801282 <strtol+0x4c>
	else if (*s == '-')
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	3c 2d                	cmp    $0x2d,%al
  801276:	75 0a                	jne    801282 <strtol+0x4c>
		s++, neg = 1;
  801278:	ff 45 08             	incl   0x8(%ebp)
  80127b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801282:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801286:	74 06                	je     80128e <strtol+0x58>
  801288:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80128c:	75 20                	jne    8012ae <strtol+0x78>
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	8a 00                	mov    (%eax),%al
  801293:	3c 30                	cmp    $0x30,%al
  801295:	75 17                	jne    8012ae <strtol+0x78>
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	40                   	inc    %eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	3c 78                	cmp    $0x78,%al
  80129f:	75 0d                	jne    8012ae <strtol+0x78>
		s += 2, base = 16;
  8012a1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012a5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012ac:	eb 28                	jmp    8012d6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b2:	75 15                	jne    8012c9 <strtol+0x93>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	3c 30                	cmp    $0x30,%al
  8012bb:	75 0c                	jne    8012c9 <strtol+0x93>
		s++, base = 8;
  8012bd:	ff 45 08             	incl   0x8(%ebp)
  8012c0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012c7:	eb 0d                	jmp    8012d6 <strtol+0xa0>
	else if (base == 0)
  8012c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012cd:	75 07                	jne    8012d6 <strtol+0xa0>
		base = 10;
  8012cf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	3c 2f                	cmp    $0x2f,%al
  8012dd:	7e 19                	jle    8012f8 <strtol+0xc2>
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	8a 00                	mov    (%eax),%al
  8012e4:	3c 39                	cmp    $0x39,%al
  8012e6:	7f 10                	jg     8012f8 <strtol+0xc2>
			dig = *s - '0';
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	8a 00                	mov    (%eax),%al
  8012ed:	0f be c0             	movsbl %al,%eax
  8012f0:	83 e8 30             	sub    $0x30,%eax
  8012f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012f6:	eb 42                	jmp    80133a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	3c 60                	cmp    $0x60,%al
  8012ff:	7e 19                	jle    80131a <strtol+0xe4>
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	8a 00                	mov    (%eax),%al
  801306:	3c 7a                	cmp    $0x7a,%al
  801308:	7f 10                	jg     80131a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	0f be c0             	movsbl %al,%eax
  801312:	83 e8 57             	sub    $0x57,%eax
  801315:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801318:	eb 20                	jmp    80133a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	3c 40                	cmp    $0x40,%al
  801321:	7e 39                	jle    80135c <strtol+0x126>
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	8a 00                	mov    (%eax),%al
  801328:	3c 5a                	cmp    $0x5a,%al
  80132a:	7f 30                	jg     80135c <strtol+0x126>
			dig = *s - 'A' + 10;
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	0f be c0             	movsbl %al,%eax
  801334:	83 e8 37             	sub    $0x37,%eax
  801337:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80133a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801340:	7d 19                	jge    80135b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801342:	ff 45 08             	incl   0x8(%ebp)
  801345:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801348:	0f af 45 10          	imul   0x10(%ebp),%eax
  80134c:	89 c2                	mov    %eax,%edx
  80134e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801351:	01 d0                	add    %edx,%eax
  801353:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801356:	e9 7b ff ff ff       	jmp    8012d6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80135b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80135c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801360:	74 08                	je     80136a <strtol+0x134>
		*endptr = (char *) s;
  801362:	8b 45 0c             	mov    0xc(%ebp),%eax
  801365:	8b 55 08             	mov    0x8(%ebp),%edx
  801368:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80136a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80136e:	74 07                	je     801377 <strtol+0x141>
  801370:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801373:	f7 d8                	neg    %eax
  801375:	eb 03                	jmp    80137a <strtol+0x144>
  801377:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <ltostr>:

void
ltostr(long value, char *str)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801389:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801390:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801394:	79 13                	jns    8013a9 <ltostr+0x2d>
	{
		neg = 1;
  801396:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80139d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013a3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013a6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013b1:	99                   	cltd   
  8013b2:	f7 f9                	idiv   %ecx
  8013b4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ba:	8d 50 01             	lea    0x1(%eax),%edx
  8013bd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c0:	89 c2                	mov    %eax,%edx
  8013c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c5:	01 d0                	add    %edx,%eax
  8013c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ca:	83 c2 30             	add    $0x30,%edx
  8013cd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013d7:	f7 e9                	imul   %ecx
  8013d9:	c1 fa 02             	sar    $0x2,%edx
  8013dc:	89 c8                	mov    %ecx,%eax
  8013de:	c1 f8 1f             	sar    $0x1f,%eax
  8013e1:	29 c2                	sub    %eax,%edx
  8013e3:	89 d0                	mov    %edx,%eax
  8013e5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8013e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013eb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013f0:	f7 e9                	imul   %ecx
  8013f2:	c1 fa 02             	sar    $0x2,%edx
  8013f5:	89 c8                	mov    %ecx,%eax
  8013f7:	c1 f8 1f             	sar    $0x1f,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
  8013fe:	c1 e0 02             	shl    $0x2,%eax
  801401:	01 d0                	add    %edx,%eax
  801403:	01 c0                	add    %eax,%eax
  801405:	29 c1                	sub    %eax,%ecx
  801407:	89 ca                	mov    %ecx,%edx
  801409:	85 d2                	test   %edx,%edx
  80140b:	75 9c                	jne    8013a9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80140d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801414:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801417:	48                   	dec    %eax
  801418:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80141b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80141f:	74 3d                	je     80145e <ltostr+0xe2>
		start = 1 ;
  801421:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801428:	eb 34                	jmp    80145e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80142a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801430:	01 d0                	add    %edx,%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801437:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c2                	add    %eax,%edx
  80143f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
  801445:	01 c8                	add    %ecx,%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80144b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	01 c2                	add    %eax,%edx
  801453:	8a 45 eb             	mov    -0x15(%ebp),%al
  801456:	88 02                	mov    %al,(%edx)
		start++ ;
  801458:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80145b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80145e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801461:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801464:	7c c4                	jl     80142a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801466:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146c:	01 d0                	add    %edx,%eax
  80146e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801471:	90                   	nop
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80147a:	ff 75 08             	pushl  0x8(%ebp)
  80147d:	e8 54 fa ff ff       	call   800ed6 <strlen>
  801482:	83 c4 04             	add    $0x4,%esp
  801485:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801488:	ff 75 0c             	pushl  0xc(%ebp)
  80148b:	e8 46 fa ff ff       	call   800ed6 <strlen>
  801490:	83 c4 04             	add    $0x4,%esp
  801493:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801496:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80149d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a4:	eb 17                	jmp    8014bd <strcconcat+0x49>
		final[s] = str1[s] ;
  8014a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ac:	01 c2                	add    %eax,%edx
  8014ae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	01 c8                	add    %ecx,%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014ba:	ff 45 fc             	incl   -0x4(%ebp)
  8014bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014c3:	7c e1                	jl     8014a6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014d3:	eb 1f                	jmp    8014f4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d8:	8d 50 01             	lea    0x1(%eax),%edx
  8014db:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014de:	89 c2                	mov    %eax,%edx
  8014e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e3:	01 c2                	add    %eax,%edx
  8014e5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014eb:	01 c8                	add    %ecx,%eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014f1:	ff 45 f8             	incl   -0x8(%ebp)
  8014f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014fa:	7c d9                	jl     8014d5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801502:	01 d0                	add    %edx,%eax
  801504:	c6 00 00             	movb   $0x0,(%eax)
}
  801507:	90                   	nop
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80150d:	8b 45 14             	mov    0x14(%ebp),%eax
  801510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801516:	8b 45 14             	mov    0x14(%ebp),%eax
  801519:	8b 00                	mov    (%eax),%eax
  80151b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801522:	8b 45 10             	mov    0x10(%ebp),%eax
  801525:	01 d0                	add    %edx,%eax
  801527:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80152d:	eb 0c                	jmp    80153b <strsplit+0x31>
			*string++ = 0;
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8d 50 01             	lea    0x1(%eax),%edx
  801535:	89 55 08             	mov    %edx,0x8(%ebp)
  801538:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	8a 00                	mov    (%eax),%al
  801540:	84 c0                	test   %al,%al
  801542:	74 18                	je     80155c <strsplit+0x52>
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	8a 00                	mov    (%eax),%al
  801549:	0f be c0             	movsbl %al,%eax
  80154c:	50                   	push   %eax
  80154d:	ff 75 0c             	pushl  0xc(%ebp)
  801550:	e8 13 fb ff ff       	call   801068 <strchr>
  801555:	83 c4 08             	add    $0x8,%esp
  801558:	85 c0                	test   %eax,%eax
  80155a:	75 d3                	jne    80152f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	8a 00                	mov    (%eax),%al
  801561:	84 c0                	test   %al,%al
  801563:	74 5a                	je     8015bf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801565:	8b 45 14             	mov    0x14(%ebp),%eax
  801568:	8b 00                	mov    (%eax),%eax
  80156a:	83 f8 0f             	cmp    $0xf,%eax
  80156d:	75 07                	jne    801576 <strsplit+0x6c>
		{
			return 0;
  80156f:	b8 00 00 00 00       	mov    $0x0,%eax
  801574:	eb 66                	jmp    8015dc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801576:	8b 45 14             	mov    0x14(%ebp),%eax
  801579:	8b 00                	mov    (%eax),%eax
  80157b:	8d 48 01             	lea    0x1(%eax),%ecx
  80157e:	8b 55 14             	mov    0x14(%ebp),%edx
  801581:	89 0a                	mov    %ecx,(%edx)
  801583:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80158a:	8b 45 10             	mov    0x10(%ebp),%eax
  80158d:	01 c2                	add    %eax,%edx
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801594:	eb 03                	jmp    801599 <strsplit+0x8f>
			string++;
  801596:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	8a 00                	mov    (%eax),%al
  80159e:	84 c0                	test   %al,%al
  8015a0:	74 8b                	je     80152d <strsplit+0x23>
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	0f be c0             	movsbl %al,%eax
  8015aa:	50                   	push   %eax
  8015ab:	ff 75 0c             	pushl  0xc(%ebp)
  8015ae:	e8 b5 fa ff ff       	call   801068 <strchr>
  8015b3:	83 c4 08             	add    $0x8,%esp
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	74 dc                	je     801596 <strsplit+0x8c>
			string++;
	}
  8015ba:	e9 6e ff ff ff       	jmp    80152d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015bf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c3:	8b 00                	mov    (%eax),%eax
  8015c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cf:	01 d0                	add    %edx,%eax
  8015d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015d7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  8015e4:	a1 28 30 80 00       	mov    0x803028,%eax
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	75 33                	jne    801620 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  8015ed:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  8015f4:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  8015f7:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  8015fe:	00 00 a0 
		spaces[0].pages = numPages;
  801601:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  801608:	00 02 00 
		spaces[0].isFree = 1;
  80160b:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  801612:	00 00 00 
		arraySize++;
  801615:	a1 28 30 80 00       	mov    0x803028,%eax
  80161a:	40                   	inc    %eax
  80161b:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  801620:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  801627:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  80162e:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801635:	8b 55 08             	mov    0x8(%ebp),%edx
  801638:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80163b:	01 d0                	add    %edx,%eax
  80163d:	48                   	dec    %eax
  80163e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801641:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801644:	ba 00 00 00 00       	mov    $0x0,%edx
  801649:	f7 75 e8             	divl   -0x18(%ebp)
  80164c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80164f:	29 d0                	sub    %edx,%eax
  801651:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	c1 e8 0c             	shr    $0xc,%eax
  80165a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  80165d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801664:	eb 57                	jmp    8016bd <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  801666:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801669:	c1 e0 04             	shl    $0x4,%eax
  80166c:	05 2c 31 80 00       	add    $0x80312c,%eax
  801671:	8b 00                	mov    (%eax),%eax
  801673:	85 c0                	test   %eax,%eax
  801675:	74 42                	je     8016b9 <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  801677:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167a:	c1 e0 04             	shl    $0x4,%eax
  80167d:	05 28 31 80 00       	add    $0x803128,%eax
  801682:	8b 00                	mov    (%eax),%eax
  801684:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801687:	7c 31                	jl     8016ba <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  801689:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168c:	c1 e0 04             	shl    $0x4,%eax
  80168f:	05 28 31 80 00       	add    $0x803128,%eax
  801694:	8b 00                	mov    (%eax),%eax
  801696:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801699:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80169c:	7d 1c                	jge    8016ba <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  80169e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a1:	c1 e0 04             	shl    $0x4,%eax
  8016a4:	05 28 31 80 00       	add    $0x803128,%eax
  8016a9:	8b 00                	mov    (%eax),%eax
  8016ab:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8016ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  8016b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016b7:	eb 01                	jmp    8016ba <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  8016b9:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  8016ba:	ff 45 ec             	incl   -0x14(%ebp)
  8016bd:	a1 28 30 80 00       	mov    0x803028,%eax
  8016c2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8016c5:	7c 9f                	jl     801666 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  8016c7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8016cb:	75 0a                	jne    8016d7 <malloc+0xf9>
	{
		return NULL;
  8016cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d2:	e9 34 01 00 00       	jmp    80180b <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  8016d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016da:	c1 e0 04             	shl    $0x4,%eax
  8016dd:	05 28 31 80 00       	add    $0x803128,%eax
  8016e2:	8b 00                	mov    (%eax),%eax
  8016e4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8016e7:	75 38                	jne    801721 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  8016e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ec:	c1 e0 04             	shl    $0x4,%eax
  8016ef:	05 2c 31 80 00       	add    $0x80312c,%eax
  8016f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  8016fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016fd:	c1 e0 0c             	shl    $0xc,%eax
  801700:	89 c2                	mov    %eax,%edx
  801702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801705:	c1 e0 04             	shl    $0x4,%eax
  801708:	05 20 31 80 00       	add    $0x803120,%eax
  80170d:	8b 00                	mov    (%eax),%eax
  80170f:	83 ec 08             	sub    $0x8,%esp
  801712:	52                   	push   %edx
  801713:	50                   	push   %eax
  801714:	e8 01 06 00 00       	call   801d1a <sys_allocateMem>
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	e9 dd 00 00 00       	jmp    8017fe <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  801721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801724:	c1 e0 04             	shl    $0x4,%eax
  801727:	05 20 31 80 00       	add    $0x803120,%eax
  80172c:	8b 00                	mov    (%eax),%eax
  80172e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801731:	c1 e2 0c             	shl    $0xc,%edx
  801734:	01 d0                	add    %edx,%eax
  801736:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  801739:	a1 28 30 80 00       	mov    0x803028,%eax
  80173e:	c1 e0 04             	shl    $0x4,%eax
  801741:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  801747:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80174a:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  80174c:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801755:	c1 e0 04             	shl    $0x4,%eax
  801758:	05 24 31 80 00       	add    $0x803124,%eax
  80175d:	8b 00                	mov    (%eax),%eax
  80175f:	c1 e2 04             	shl    $0x4,%edx
  801762:	81 c2 24 31 80 00    	add    $0x803124,%edx
  801768:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  80176a:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801773:	c1 e0 04             	shl    $0x4,%eax
  801776:	05 28 31 80 00       	add    $0x803128,%eax
  80177b:	8b 00                	mov    (%eax),%eax
  80177d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801780:	c1 e2 04             	shl    $0x4,%edx
  801783:	81 c2 28 31 80 00    	add    $0x803128,%edx
  801789:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  80178b:	a1 28 30 80 00       	mov    0x803028,%eax
  801790:	c1 e0 04             	shl    $0x4,%eax
  801793:	05 2c 31 80 00       	add    $0x80312c,%eax
  801798:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  80179e:	a1 28 30 80 00       	mov    0x803028,%eax
  8017a3:	40                   	inc    %eax
  8017a4:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  8017a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ac:	c1 e0 04             	shl    $0x4,%eax
  8017af:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  8017b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017b8:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  8017ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bd:	c1 e0 04             	shl    $0x4,%eax
  8017c0:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  8017c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017c9:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  8017cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ce:	c1 e0 04             	shl    $0x4,%eax
  8017d1:	05 2c 31 80 00       	add    $0x80312c,%eax
  8017d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  8017dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017df:	c1 e0 0c             	shl    $0xc,%eax
  8017e2:	89 c2                	mov    %eax,%edx
  8017e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e7:	c1 e0 04             	shl    $0x4,%eax
  8017ea:	05 20 31 80 00       	add    $0x803120,%eax
  8017ef:	8b 00                	mov    (%eax),%eax
  8017f1:	83 ec 08             	sub    $0x8,%esp
  8017f4:	52                   	push   %edx
  8017f5:	50                   	push   %eax
  8017f6:	e8 1f 05 00 00       	call   801d1a <sys_allocateMem>
  8017fb:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  8017fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801801:	c1 e0 04             	shl    $0x4,%eax
  801804:	05 20 31 80 00       	add    $0x803120,%eax
  801809:	8b 00                	mov    (%eax),%eax
	}


}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  801813:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  80181a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801821:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801828:	eb 3f                	jmp    801869 <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  80182a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80182d:	c1 e0 04             	shl    $0x4,%eax
  801830:	05 20 31 80 00       	add    $0x803120,%eax
  801835:	8b 00                	mov    (%eax),%eax
  801837:	3b 45 08             	cmp    0x8(%ebp),%eax
  80183a:	75 2a                	jne    801866 <free+0x59>
		{
			index=i;
  80183c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80183f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  801842:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801845:	c1 e0 04             	shl    $0x4,%eax
  801848:	05 28 31 80 00       	add    $0x803128,%eax
  80184d:	8b 00                	mov    (%eax),%eax
  80184f:	c1 e0 0c             	shl    $0xc,%eax
  801852:	89 c2                	mov    %eax,%edx
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	83 ec 08             	sub    $0x8,%esp
  80185a:	52                   	push   %edx
  80185b:	50                   	push   %eax
  80185c:	e8 9d 04 00 00       	call   801cfe <sys_freeMem>
  801861:	83 c4 10             	add    $0x10,%esp
			break;
  801864:	eb 0d                	jmp    801873 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  801866:	ff 45 ec             	incl   -0x14(%ebp)
  801869:	a1 28 30 80 00       	mov    0x803028,%eax
  80186e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801871:	7c b7                	jl     80182a <free+0x1d>
			break;
		}

	}

	if(index == -1)
  801873:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801877:	75 17                	jne    801890 <free+0x83>
	{
		panic("Error");
  801879:	83 ec 04             	sub    $0x4,%esp
  80187c:	68 90 2e 80 00       	push   $0x802e90
  801881:	68 81 00 00 00       	push   $0x81
  801886:	68 96 2e 80 00       	push   $0x802e96
  80188b:	e8 22 ed ff ff       	call   8005b2 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  801890:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801897:	e9 cc 00 00 00       	jmp    801968 <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  80189c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80189f:	c1 e0 04             	shl    $0x4,%eax
  8018a2:	05 2c 31 80 00       	add    $0x80312c,%eax
  8018a7:	8b 00                	mov    (%eax),%eax
  8018a9:	85 c0                	test   %eax,%eax
  8018ab:	0f 84 b3 00 00 00    	je     801964 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  8018b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b4:	c1 e0 04             	shl    $0x4,%eax
  8018b7:	05 20 31 80 00       	add    $0x803120,%eax
  8018bc:	8b 10                	mov    (%eax),%edx
  8018be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c1:	c1 e0 04             	shl    $0x4,%eax
  8018c4:	05 24 31 80 00       	add    $0x803124,%eax
  8018c9:	8b 00                	mov    (%eax),%eax
  8018cb:	39 c2                	cmp    %eax,%edx
  8018cd:	0f 85 92 00 00 00    	jne    801965 <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  8018d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d6:	c1 e0 04             	shl    $0x4,%eax
  8018d9:	05 24 31 80 00       	add    $0x803124,%eax
  8018de:	8b 00                	mov    (%eax),%eax
  8018e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018e3:	c1 e2 04             	shl    $0x4,%edx
  8018e6:	81 c2 24 31 80 00    	add    $0x803124,%edx
  8018ec:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  8018ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018f1:	c1 e0 04             	shl    $0x4,%eax
  8018f4:	05 28 31 80 00       	add    $0x803128,%eax
  8018f9:	8b 10                	mov    (%eax),%edx
  8018fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fe:	c1 e0 04             	shl    $0x4,%eax
  801901:	05 28 31 80 00       	add    $0x803128,%eax
  801906:	8b 00                	mov    (%eax),%eax
  801908:	01 c2                	add    %eax,%edx
  80190a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80190d:	c1 e0 04             	shl    $0x4,%eax
  801910:	05 28 31 80 00       	add    $0x803128,%eax
  801915:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191a:	c1 e0 04             	shl    $0x4,%eax
  80191d:	05 20 31 80 00       	add    $0x803120,%eax
  801922:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192b:	c1 e0 04             	shl    $0x4,%eax
  80192e:	05 24 31 80 00       	add    $0x803124,%eax
  801933:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193c:	c1 e0 04             	shl    $0x4,%eax
  80193f:	05 28 31 80 00       	add    $0x803128,%eax
  801944:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  80194a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194d:	c1 e0 04             	shl    $0x4,%eax
  801950:	05 2c 31 80 00       	add    $0x80312c,%eax
  801955:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  80195b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801962:	eb 12                	jmp    801976 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801964:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801965:	ff 45 e8             	incl   -0x18(%ebp)
  801968:	a1 28 30 80 00       	mov    0x803028,%eax
  80196d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801970:	0f 8c 26 ff ff ff    	jl     80189c <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801976:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80197d:	e9 cc 00 00 00       	jmp    801a4e <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  801982:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801985:	c1 e0 04             	shl    $0x4,%eax
  801988:	05 2c 31 80 00       	add    $0x80312c,%eax
  80198d:	8b 00                	mov    (%eax),%eax
  80198f:	85 c0                	test   %eax,%eax
  801991:	0f 84 b3 00 00 00    	je     801a4a <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  801997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199a:	c1 e0 04             	shl    $0x4,%eax
  80199d:	05 24 31 80 00       	add    $0x803124,%eax
  8019a2:	8b 10                	mov    (%eax),%edx
  8019a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019a7:	c1 e0 04             	shl    $0x4,%eax
  8019aa:	05 20 31 80 00       	add    $0x803120,%eax
  8019af:	8b 00                	mov    (%eax),%eax
  8019b1:	39 c2                	cmp    %eax,%edx
  8019b3:	0f 85 92 00 00 00    	jne    801a4b <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  8019b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bc:	c1 e0 04             	shl    $0x4,%eax
  8019bf:	05 20 31 80 00       	add    $0x803120,%eax
  8019c4:	8b 00                	mov    (%eax),%eax
  8019c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019c9:	c1 e2 04             	shl    $0x4,%edx
  8019cc:	81 c2 20 31 80 00    	add    $0x803120,%edx
  8019d2:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  8019d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019d7:	c1 e0 04             	shl    $0x4,%eax
  8019da:	05 28 31 80 00       	add    $0x803128,%eax
  8019df:	8b 10                	mov    (%eax),%edx
  8019e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e4:	c1 e0 04             	shl    $0x4,%eax
  8019e7:	05 28 31 80 00       	add    $0x803128,%eax
  8019ec:	8b 00                	mov    (%eax),%eax
  8019ee:	01 c2                	add    %eax,%edx
  8019f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019f3:	c1 e0 04             	shl    $0x4,%eax
  8019f6:	05 28 31 80 00       	add    $0x803128,%eax
  8019fb:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  8019fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a00:	c1 e0 04             	shl    $0x4,%eax
  801a03:	05 20 31 80 00       	add    $0x803120,%eax
  801a08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a11:	c1 e0 04             	shl    $0x4,%eax
  801a14:	05 24 31 80 00       	add    $0x803124,%eax
  801a19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a22:	c1 e0 04             	shl    $0x4,%eax
  801a25:	05 28 31 80 00       	add    $0x803128,%eax
  801a2a:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a33:	c1 e0 04             	shl    $0x4,%eax
  801a36:	05 2c 31 80 00       	add    $0x80312c,%eax
  801a3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801a41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801a48:	eb 12                	jmp    801a5c <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801a4a:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801a4b:	ff 45 e4             	incl   -0x1c(%ebp)
  801a4e:	a1 28 30 80 00       	mov    0x803028,%eax
  801a53:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a56:	0f 8c 26 ff ff ff    	jl     801982 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  801a5c:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801a60:	75 11                	jne    801a73 <free+0x266>
	{
		spaces[index].isFree = 1;
  801a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a65:	c1 e0 04             	shl    $0x4,%eax
  801a68:	05 2c 31 80 00       	add    $0x80312c,%eax
  801a6d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  801a73:	90                   	nop
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 18             	sub    $0x18,%esp
  801a7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7f:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801a82:	83 ec 04             	sub    $0x4,%esp
  801a85:	68 a4 2e 80 00       	push   $0x802ea4
  801a8a:	68 b9 00 00 00       	push   $0xb9
  801a8f:	68 96 2e 80 00       	push   $0x802e96
  801a94:	e8 19 eb ff ff       	call   8005b2 <_panic>

00801a99 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a9f:	83 ec 04             	sub    $0x4,%esp
  801aa2:	68 a4 2e 80 00       	push   $0x802ea4
  801aa7:	68 bf 00 00 00       	push   $0xbf
  801aac:	68 96 2e 80 00       	push   $0x802e96
  801ab1:	e8 fc ea ff ff       	call   8005b2 <_panic>

00801ab6 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801abc:	83 ec 04             	sub    $0x4,%esp
  801abf:	68 a4 2e 80 00       	push   $0x802ea4
  801ac4:	68 c5 00 00 00       	push   $0xc5
  801ac9:	68 96 2e 80 00       	push   $0x802e96
  801ace:	e8 df ea ff ff       	call   8005b2 <_panic>

00801ad3 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ad9:	83 ec 04             	sub    $0x4,%esp
  801adc:	68 a4 2e 80 00       	push   $0x802ea4
  801ae1:	68 ca 00 00 00       	push   $0xca
  801ae6:	68 96 2e 80 00       	push   $0x802e96
  801aeb:	e8 c2 ea ff ff       	call   8005b2 <_panic>

00801af0 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801af6:	83 ec 04             	sub    $0x4,%esp
  801af9:	68 a4 2e 80 00       	push   $0x802ea4
  801afe:	68 d0 00 00 00       	push   $0xd0
  801b03:	68 96 2e 80 00       	push   $0x802e96
  801b08:	e8 a5 ea ff ff       	call   8005b2 <_panic>

00801b0d <shrink>:
}
void shrink(uint32 newSize)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b13:	83 ec 04             	sub    $0x4,%esp
  801b16:	68 a4 2e 80 00       	push   $0x802ea4
  801b1b:	68 d4 00 00 00       	push   $0xd4
  801b20:	68 96 2e 80 00       	push   $0x802e96
  801b25:	e8 88 ea ff ff       	call   8005b2 <_panic>

00801b2a <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b30:	83 ec 04             	sub    $0x4,%esp
  801b33:	68 a4 2e 80 00       	push   $0x802ea4
  801b38:	68 d9 00 00 00       	push   $0xd9
  801b3d:	68 96 2e 80 00       	push   $0x802e96
  801b42:	e8 6b ea ff ff       	call   8005b2 <_panic>

00801b47 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	57                   	push   %edi
  801b4b:	56                   	push   %esi
  801b4c:	53                   	push   %ebx
  801b4d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b56:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b59:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b5c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b5f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b62:	cd 30                	int    $0x30
  801b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b6a:	83 c4 10             	add    $0x10,%esp
  801b6d:	5b                   	pop    %ebx
  801b6e:	5e                   	pop    %esi
  801b6f:	5f                   	pop    %edi
  801b70:	5d                   	pop    %ebp
  801b71:	c3                   	ret    

00801b72 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 04             	sub    $0x4,%esp
  801b78:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b7e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	52                   	push   %edx
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	50                   	push   %eax
  801b8e:	6a 00                	push   $0x0
  801b90:	e8 b2 ff ff ff       	call   801b47 <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
}
  801b98:	90                   	nop
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_cgetc>:

int
sys_cgetc(void)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 01                	push   $0x1
  801baa:	e8 98 ff ff ff       	call   801b47 <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	50                   	push   %eax
  801bc3:	6a 05                	push   $0x5
  801bc5:	e8 7d ff ff ff       	call   801b47 <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 02                	push   $0x2
  801bde:	e8 64 ff ff ff       	call   801b47 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 03                	push   $0x3
  801bf7:	e8 4b ff ff ff       	call   801b47 <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 04                	push   $0x4
  801c10:	e8 32 ff ff ff       	call   801b47 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_env_exit>:


void sys_env_exit(void)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 06                	push   $0x6
  801c29:	e8 19 ff ff ff       	call   801b47 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	90                   	nop
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	52                   	push   %edx
  801c44:	50                   	push   %eax
  801c45:	6a 07                	push   $0x7
  801c47:	e8 fb fe ff ff       	call   801b47 <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	56                   	push   %esi
  801c55:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c56:	8b 75 18             	mov    0x18(%ebp),%esi
  801c59:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	56                   	push   %esi
  801c66:	53                   	push   %ebx
  801c67:	51                   	push   %ecx
  801c68:	52                   	push   %edx
  801c69:	50                   	push   %eax
  801c6a:	6a 08                	push   $0x8
  801c6c:	e8 d6 fe ff ff       	call   801b47 <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c77:	5b                   	pop    %ebx
  801c78:	5e                   	pop    %esi
  801c79:	5d                   	pop    %ebp
  801c7a:	c3                   	ret    

00801c7b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	52                   	push   %edx
  801c8b:	50                   	push   %eax
  801c8c:	6a 09                	push   $0x9
  801c8e:	e8 b4 fe ff ff       	call   801b47 <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	ff 75 0c             	pushl  0xc(%ebp)
  801ca4:	ff 75 08             	pushl  0x8(%ebp)
  801ca7:	6a 0a                	push   $0xa
  801ca9:	e8 99 fe ff ff       	call   801b47 <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 0b                	push   $0xb
  801cc2:	e8 80 fe ff ff       	call   801b47 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 0c                	push   $0xc
  801cdb:	e8 67 fe ff ff       	call   801b47 <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 0d                	push   $0xd
  801cf4:	e8 4e fe ff ff       	call   801b47 <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	ff 75 0c             	pushl  0xc(%ebp)
  801d0a:	ff 75 08             	pushl  0x8(%ebp)
  801d0d:	6a 11                	push   $0x11
  801d0f:	e8 33 fe ff ff       	call   801b47 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
	return;
  801d17:	90                   	nop
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	ff 75 0c             	pushl  0xc(%ebp)
  801d26:	ff 75 08             	pushl  0x8(%ebp)
  801d29:	6a 12                	push   $0x12
  801d2b:	e8 17 fe ff ff       	call   801b47 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
	return ;
  801d33:	90                   	nop
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 0e                	push   $0xe
  801d45:	e8 fd fd ff ff       	call   801b47 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
}
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	ff 75 08             	pushl  0x8(%ebp)
  801d5d:	6a 0f                	push   $0xf
  801d5f:	e8 e3 fd ff ff       	call   801b47 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 10                	push   $0x10
  801d78:	e8 ca fd ff ff       	call   801b47 <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
}
  801d80:	90                   	nop
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 14                	push   $0x14
  801d92:	e8 b0 fd ff ff       	call   801b47 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
}
  801d9a:	90                   	nop
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 15                	push   $0x15
  801dac:	e8 96 fd ff ff       	call   801b47 <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
}
  801db4:	90                   	nop
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_cputc>:


void
sys_cputc(const char c)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	83 ec 04             	sub    $0x4,%esp
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801dc3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	50                   	push   %eax
  801dd0:	6a 16                	push   $0x16
  801dd2:	e8 70 fd ff ff       	call   801b47 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
}
  801dda:	90                   	nop
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 17                	push   $0x17
  801dec:	e8 56 fd ff ff       	call   801b47 <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
}
  801df4:	90                   	nop
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	ff 75 0c             	pushl  0xc(%ebp)
  801e06:	50                   	push   %eax
  801e07:	6a 18                	push   $0x18
  801e09:	e8 39 fd ff ff       	call   801b47 <syscall>
  801e0e:	83 c4 18             	add    $0x18,%esp
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	52                   	push   %edx
  801e23:	50                   	push   %eax
  801e24:	6a 1b                	push   $0x1b
  801e26:	e8 1c fd ff ff       	call   801b47 <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	52                   	push   %edx
  801e40:	50                   	push   %eax
  801e41:	6a 19                	push   $0x19
  801e43:	e8 ff fc ff ff       	call   801b47 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	90                   	nop
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	52                   	push   %edx
  801e5e:	50                   	push   %eax
  801e5f:	6a 1a                	push   $0x1a
  801e61:	e8 e1 fc ff ff       	call   801b47 <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
}
  801e69:	90                   	nop
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 04             	sub    $0x4,%esp
  801e72:	8b 45 10             	mov    0x10(%ebp),%eax
  801e75:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e78:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e7b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	6a 00                	push   $0x0
  801e84:	51                   	push   %ecx
  801e85:	52                   	push   %edx
  801e86:	ff 75 0c             	pushl  0xc(%ebp)
  801e89:	50                   	push   %eax
  801e8a:	6a 1c                	push   $0x1c
  801e8c:	e8 b6 fc ff ff       	call   801b47 <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	52                   	push   %edx
  801ea6:	50                   	push   %eax
  801ea7:	6a 1d                	push   $0x1d
  801ea9:	e8 99 fc ff ff       	call   801b47 <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801eb6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	51                   	push   %ecx
  801ec4:	52                   	push   %edx
  801ec5:	50                   	push   %eax
  801ec6:	6a 1e                	push   $0x1e
  801ec8:	e8 7a fc ff ff       	call   801b47 <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	52                   	push   %edx
  801ee2:	50                   	push   %eax
  801ee3:	6a 1f                	push   $0x1f
  801ee5:	e8 5d fc ff ff       	call   801b47 <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 20                	push   $0x20
  801efe:	e8 44 fc ff ff       	call   801b47 <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	6a 00                	push   $0x0
  801f10:	ff 75 14             	pushl  0x14(%ebp)
  801f13:	ff 75 10             	pushl  0x10(%ebp)
  801f16:	ff 75 0c             	pushl  0xc(%ebp)
  801f19:	50                   	push   %eax
  801f1a:	6a 21                	push   $0x21
  801f1c:	e8 26 fc ff ff       	call   801b47 <syscall>
  801f21:	83 c4 18             	add    $0x18,%esp
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	50                   	push   %eax
  801f35:	6a 22                	push   $0x22
  801f37:	e8 0b fc ff ff       	call   801b47 <syscall>
  801f3c:	83 c4 18             	add    $0x18,%esp
}
  801f3f:	90                   	nop
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	50                   	push   %eax
  801f51:	6a 23                	push   $0x23
  801f53:	e8 ef fb ff ff       	call   801b47 <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
}
  801f5b:	90                   	nop
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f64:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f67:	8d 50 04             	lea    0x4(%eax),%edx
  801f6a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	52                   	push   %edx
  801f74:	50                   	push   %eax
  801f75:	6a 24                	push   $0x24
  801f77:	e8 cb fb ff ff       	call   801b47 <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
	return result;
  801f7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f85:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f88:	89 01                	mov    %eax,(%ecx)
  801f8a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	c9                   	leave  
  801f91:	c2 04 00             	ret    $0x4

00801f94 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	ff 75 10             	pushl  0x10(%ebp)
  801f9e:	ff 75 0c             	pushl  0xc(%ebp)
  801fa1:	ff 75 08             	pushl  0x8(%ebp)
  801fa4:	6a 13                	push   $0x13
  801fa6:	e8 9c fb ff ff       	call   801b47 <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
	return ;
  801fae:	90                   	nop
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 25                	push   $0x25
  801fc0:	e8 82 fb ff ff       	call   801b47 <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	83 ec 04             	sub    $0x4,%esp
  801fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fd6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	50                   	push   %eax
  801fe3:	6a 26                	push   $0x26
  801fe5:	e8 5d fb ff ff       	call   801b47 <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
	return ;
  801fed:	90                   	nop
}
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <rsttst>:
void rsttst()
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 28                	push   $0x28
  801fff:	e8 43 fb ff ff       	call   801b47 <syscall>
  802004:	83 c4 18             	add    $0x18,%esp
	return ;
  802007:	90                   	nop
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	83 ec 04             	sub    $0x4,%esp
  802010:	8b 45 14             	mov    0x14(%ebp),%eax
  802013:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802016:	8b 55 18             	mov    0x18(%ebp),%edx
  802019:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80201d:	52                   	push   %edx
  80201e:	50                   	push   %eax
  80201f:	ff 75 10             	pushl  0x10(%ebp)
  802022:	ff 75 0c             	pushl  0xc(%ebp)
  802025:	ff 75 08             	pushl  0x8(%ebp)
  802028:	6a 27                	push   $0x27
  80202a:	e8 18 fb ff ff       	call   801b47 <syscall>
  80202f:	83 c4 18             	add    $0x18,%esp
	return ;
  802032:	90                   	nop
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <chktst>:
void chktst(uint32 n)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	ff 75 08             	pushl  0x8(%ebp)
  802043:	6a 29                	push   $0x29
  802045:	e8 fd fa ff ff       	call   801b47 <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
	return ;
  80204d:	90                   	nop
}
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <inctst>:

void inctst()
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 2a                	push   $0x2a
  80205f:	e8 e3 fa ff ff       	call   801b47 <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
	return ;
  802067:	90                   	nop
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <gettst>:
uint32 gettst()
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 2b                	push   $0x2b
  802079:	e8 c9 fa ff ff       	call   801b47 <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 2c                	push   $0x2c
  802095:	e8 ad fa ff ff       	call   801b47 <syscall>
  80209a:	83 c4 18             	add    $0x18,%esp
  80209d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8020a0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020a4:	75 07                	jne    8020ad <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ab:	eb 05                	jmp    8020b2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 2c                	push   $0x2c
  8020c6:	e8 7c fa ff ff       	call   801b47 <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
  8020ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020d1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020d5:	75 07                	jne    8020de <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8020dc:	eb 05                	jmp    8020e3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 2c                	push   $0x2c
  8020f7:	e8 4b fa ff ff       	call   801b47 <syscall>
  8020fc:	83 c4 18             	add    $0x18,%esp
  8020ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802102:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802106:	75 07                	jne    80210f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802108:	b8 01 00 00 00       	mov    $0x1,%eax
  80210d:	eb 05                	jmp    802114 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80210f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 2c                	push   $0x2c
  802128:	e8 1a fa ff ff       	call   801b47 <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
  802130:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802133:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802137:	75 07                	jne    802140 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802139:	b8 01 00 00 00       	mov    $0x1,%eax
  80213e:	eb 05                	jmp    802145 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802140:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	ff 75 08             	pushl  0x8(%ebp)
  802155:	6a 2d                	push   $0x2d
  802157:	e8 eb f9 ff ff       	call   801b47 <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
	return ;
  80215f:	90                   	nop
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802166:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802169:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80216c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	6a 00                	push   $0x0
  802174:	53                   	push   %ebx
  802175:	51                   	push   %ecx
  802176:	52                   	push   %edx
  802177:	50                   	push   %eax
  802178:	6a 2e                	push   $0x2e
  80217a:	e8 c8 f9 ff ff       	call   801b47 <syscall>
  80217f:	83 c4 18             	add    $0x18,%esp
}
  802182:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80218a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	52                   	push   %edx
  802197:	50                   	push   %eax
  802198:	6a 2f                	push   $0x2f
  80219a:	e8 a8 f9 ff ff       	call   801b47 <syscall>
  80219f:	83 c4 18             	add    $0x18,%esp
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8021aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ad:	89 d0                	mov    %edx,%eax
  8021af:	c1 e0 02             	shl    $0x2,%eax
  8021b2:	01 d0                	add    %edx,%eax
  8021b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8021bb:	01 d0                	add    %edx,%eax
  8021bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8021c4:	01 d0                	add    %edx,%eax
  8021c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8021cd:	01 d0                	add    %edx,%eax
  8021cf:	c1 e0 04             	shl    $0x4,%eax
  8021d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8021d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8021dc:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8021df:	83 ec 0c             	sub    $0xc,%esp
  8021e2:	50                   	push   %eax
  8021e3:	e8 76 fd ff ff       	call   801f5e <sys_get_virtual_time>
  8021e8:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8021eb:	eb 41                	jmp    80222e <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8021ed:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8021f0:	83 ec 0c             	sub    $0xc,%esp
  8021f3:	50                   	push   %eax
  8021f4:	e8 65 fd ff ff       	call   801f5e <sys_get_virtual_time>
  8021f9:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8021fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802202:	29 c2                	sub    %eax,%edx
  802204:	89 d0                	mov    %edx,%eax
  802206:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802209:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80220c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220f:	89 d1                	mov    %edx,%ecx
  802211:	29 c1                	sub    %eax,%ecx
  802213:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802216:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802219:	39 c2                	cmp    %eax,%edx
  80221b:	0f 97 c0             	seta   %al
  80221e:	0f b6 c0             	movzbl %al,%eax
  802221:	29 c1                	sub    %eax,%ecx
  802223:	89 c8                	mov    %ecx,%eax
  802225:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802228:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80222b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802234:	72 b7                	jb     8021ed <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802236:	90                   	nop
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80223f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802246:	eb 03                	jmp    80224b <busy_wait+0x12>
  802248:	ff 45 fc             	incl   -0x4(%ebp)
  80224b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80224e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802251:	72 f5                	jb     802248 <busy_wait+0xf>
	return i;
  802253:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <__udivdi3>:
  802258:	55                   	push   %ebp
  802259:	57                   	push   %edi
  80225a:	56                   	push   %esi
  80225b:	53                   	push   %ebx
  80225c:	83 ec 1c             	sub    $0x1c,%esp
  80225f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802263:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802267:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80226b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80226f:	89 ca                	mov    %ecx,%edx
  802271:	89 f8                	mov    %edi,%eax
  802273:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802277:	85 f6                	test   %esi,%esi
  802279:	75 2d                	jne    8022a8 <__udivdi3+0x50>
  80227b:	39 cf                	cmp    %ecx,%edi
  80227d:	77 65                	ja     8022e4 <__udivdi3+0x8c>
  80227f:	89 fd                	mov    %edi,%ebp
  802281:	85 ff                	test   %edi,%edi
  802283:	75 0b                	jne    802290 <__udivdi3+0x38>
  802285:	b8 01 00 00 00       	mov    $0x1,%eax
  80228a:	31 d2                	xor    %edx,%edx
  80228c:	f7 f7                	div    %edi
  80228e:	89 c5                	mov    %eax,%ebp
  802290:	31 d2                	xor    %edx,%edx
  802292:	89 c8                	mov    %ecx,%eax
  802294:	f7 f5                	div    %ebp
  802296:	89 c1                	mov    %eax,%ecx
  802298:	89 d8                	mov    %ebx,%eax
  80229a:	f7 f5                	div    %ebp
  80229c:	89 cf                	mov    %ecx,%edi
  80229e:	89 fa                	mov    %edi,%edx
  8022a0:	83 c4 1c             	add    $0x1c,%esp
  8022a3:	5b                   	pop    %ebx
  8022a4:	5e                   	pop    %esi
  8022a5:	5f                   	pop    %edi
  8022a6:	5d                   	pop    %ebp
  8022a7:	c3                   	ret    
  8022a8:	39 ce                	cmp    %ecx,%esi
  8022aa:	77 28                	ja     8022d4 <__udivdi3+0x7c>
  8022ac:	0f bd fe             	bsr    %esi,%edi
  8022af:	83 f7 1f             	xor    $0x1f,%edi
  8022b2:	75 40                	jne    8022f4 <__udivdi3+0x9c>
  8022b4:	39 ce                	cmp    %ecx,%esi
  8022b6:	72 0a                	jb     8022c2 <__udivdi3+0x6a>
  8022b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8022bc:	0f 87 9e 00 00 00    	ja     802360 <__udivdi3+0x108>
  8022c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c7:	89 fa                	mov    %edi,%edx
  8022c9:	83 c4 1c             	add    $0x1c,%esp
  8022cc:	5b                   	pop    %ebx
  8022cd:	5e                   	pop    %esi
  8022ce:	5f                   	pop    %edi
  8022cf:	5d                   	pop    %ebp
  8022d0:	c3                   	ret    
  8022d1:	8d 76 00             	lea    0x0(%esi),%esi
  8022d4:	31 ff                	xor    %edi,%edi
  8022d6:	31 c0                	xor    %eax,%eax
  8022d8:	89 fa                	mov    %edi,%edx
  8022da:	83 c4 1c             	add    $0x1c,%esp
  8022dd:	5b                   	pop    %ebx
  8022de:	5e                   	pop    %esi
  8022df:	5f                   	pop    %edi
  8022e0:	5d                   	pop    %ebp
  8022e1:	c3                   	ret    
  8022e2:	66 90                	xchg   %ax,%ax
  8022e4:	89 d8                	mov    %ebx,%eax
  8022e6:	f7 f7                	div    %edi
  8022e8:	31 ff                	xor    %edi,%edi
  8022ea:	89 fa                	mov    %edi,%edx
  8022ec:	83 c4 1c             	add    $0x1c,%esp
  8022ef:	5b                   	pop    %ebx
  8022f0:	5e                   	pop    %esi
  8022f1:	5f                   	pop    %edi
  8022f2:	5d                   	pop    %ebp
  8022f3:	c3                   	ret    
  8022f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8022f9:	89 eb                	mov    %ebp,%ebx
  8022fb:	29 fb                	sub    %edi,%ebx
  8022fd:	89 f9                	mov    %edi,%ecx
  8022ff:	d3 e6                	shl    %cl,%esi
  802301:	89 c5                	mov    %eax,%ebp
  802303:	88 d9                	mov    %bl,%cl
  802305:	d3 ed                	shr    %cl,%ebp
  802307:	89 e9                	mov    %ebp,%ecx
  802309:	09 f1                	or     %esi,%ecx
  80230b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80230f:	89 f9                	mov    %edi,%ecx
  802311:	d3 e0                	shl    %cl,%eax
  802313:	89 c5                	mov    %eax,%ebp
  802315:	89 d6                	mov    %edx,%esi
  802317:	88 d9                	mov    %bl,%cl
  802319:	d3 ee                	shr    %cl,%esi
  80231b:	89 f9                	mov    %edi,%ecx
  80231d:	d3 e2                	shl    %cl,%edx
  80231f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802323:	88 d9                	mov    %bl,%cl
  802325:	d3 e8                	shr    %cl,%eax
  802327:	09 c2                	or     %eax,%edx
  802329:	89 d0                	mov    %edx,%eax
  80232b:	89 f2                	mov    %esi,%edx
  80232d:	f7 74 24 0c          	divl   0xc(%esp)
  802331:	89 d6                	mov    %edx,%esi
  802333:	89 c3                	mov    %eax,%ebx
  802335:	f7 e5                	mul    %ebp
  802337:	39 d6                	cmp    %edx,%esi
  802339:	72 19                	jb     802354 <__udivdi3+0xfc>
  80233b:	74 0b                	je     802348 <__udivdi3+0xf0>
  80233d:	89 d8                	mov    %ebx,%eax
  80233f:	31 ff                	xor    %edi,%edi
  802341:	e9 58 ff ff ff       	jmp    80229e <__udivdi3+0x46>
  802346:	66 90                	xchg   %ax,%ax
  802348:	8b 54 24 08          	mov    0x8(%esp),%edx
  80234c:	89 f9                	mov    %edi,%ecx
  80234e:	d3 e2                	shl    %cl,%edx
  802350:	39 c2                	cmp    %eax,%edx
  802352:	73 e9                	jae    80233d <__udivdi3+0xe5>
  802354:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802357:	31 ff                	xor    %edi,%edi
  802359:	e9 40 ff ff ff       	jmp    80229e <__udivdi3+0x46>
  80235e:	66 90                	xchg   %ax,%ax
  802360:	31 c0                	xor    %eax,%eax
  802362:	e9 37 ff ff ff       	jmp    80229e <__udivdi3+0x46>
  802367:	90                   	nop

00802368 <__umoddi3>:
  802368:	55                   	push   %ebp
  802369:	57                   	push   %edi
  80236a:	56                   	push   %esi
  80236b:	53                   	push   %ebx
  80236c:	83 ec 1c             	sub    $0x1c,%esp
  80236f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802373:	8b 74 24 34          	mov    0x34(%esp),%esi
  802377:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80237b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80237f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802383:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802387:	89 f3                	mov    %esi,%ebx
  802389:	89 fa                	mov    %edi,%edx
  80238b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80238f:	89 34 24             	mov    %esi,(%esp)
  802392:	85 c0                	test   %eax,%eax
  802394:	75 1a                	jne    8023b0 <__umoddi3+0x48>
  802396:	39 f7                	cmp    %esi,%edi
  802398:	0f 86 a2 00 00 00    	jbe    802440 <__umoddi3+0xd8>
  80239e:	89 c8                	mov    %ecx,%eax
  8023a0:	89 f2                	mov    %esi,%edx
  8023a2:	f7 f7                	div    %edi
  8023a4:	89 d0                	mov    %edx,%eax
  8023a6:	31 d2                	xor    %edx,%edx
  8023a8:	83 c4 1c             	add    $0x1c,%esp
  8023ab:	5b                   	pop    %ebx
  8023ac:	5e                   	pop    %esi
  8023ad:	5f                   	pop    %edi
  8023ae:	5d                   	pop    %ebp
  8023af:	c3                   	ret    
  8023b0:	39 f0                	cmp    %esi,%eax
  8023b2:	0f 87 ac 00 00 00    	ja     802464 <__umoddi3+0xfc>
  8023b8:	0f bd e8             	bsr    %eax,%ebp
  8023bb:	83 f5 1f             	xor    $0x1f,%ebp
  8023be:	0f 84 ac 00 00 00    	je     802470 <__umoddi3+0x108>
  8023c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8023c9:	29 ef                	sub    %ebp,%edi
  8023cb:	89 fe                	mov    %edi,%esi
  8023cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023d1:	89 e9                	mov    %ebp,%ecx
  8023d3:	d3 e0                	shl    %cl,%eax
  8023d5:	89 d7                	mov    %edx,%edi
  8023d7:	89 f1                	mov    %esi,%ecx
  8023d9:	d3 ef                	shr    %cl,%edi
  8023db:	09 c7                	or     %eax,%edi
  8023dd:	89 e9                	mov    %ebp,%ecx
  8023df:	d3 e2                	shl    %cl,%edx
  8023e1:	89 14 24             	mov    %edx,(%esp)
  8023e4:	89 d8                	mov    %ebx,%eax
  8023e6:	d3 e0                	shl    %cl,%eax
  8023e8:	89 c2                	mov    %eax,%edx
  8023ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023ee:	d3 e0                	shl    %cl,%eax
  8023f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023f8:	89 f1                	mov    %esi,%ecx
  8023fa:	d3 e8                	shr    %cl,%eax
  8023fc:	09 d0                	or     %edx,%eax
  8023fe:	d3 eb                	shr    %cl,%ebx
  802400:	89 da                	mov    %ebx,%edx
  802402:	f7 f7                	div    %edi
  802404:	89 d3                	mov    %edx,%ebx
  802406:	f7 24 24             	mull   (%esp)
  802409:	89 c6                	mov    %eax,%esi
  80240b:	89 d1                	mov    %edx,%ecx
  80240d:	39 d3                	cmp    %edx,%ebx
  80240f:	0f 82 87 00 00 00    	jb     80249c <__umoddi3+0x134>
  802415:	0f 84 91 00 00 00    	je     8024ac <__umoddi3+0x144>
  80241b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80241f:	29 f2                	sub    %esi,%edx
  802421:	19 cb                	sbb    %ecx,%ebx
  802423:	89 d8                	mov    %ebx,%eax
  802425:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802429:	d3 e0                	shl    %cl,%eax
  80242b:	89 e9                	mov    %ebp,%ecx
  80242d:	d3 ea                	shr    %cl,%edx
  80242f:	09 d0                	or     %edx,%eax
  802431:	89 e9                	mov    %ebp,%ecx
  802433:	d3 eb                	shr    %cl,%ebx
  802435:	89 da                	mov    %ebx,%edx
  802437:	83 c4 1c             	add    $0x1c,%esp
  80243a:	5b                   	pop    %ebx
  80243b:	5e                   	pop    %esi
  80243c:	5f                   	pop    %edi
  80243d:	5d                   	pop    %ebp
  80243e:	c3                   	ret    
  80243f:	90                   	nop
  802440:	89 fd                	mov    %edi,%ebp
  802442:	85 ff                	test   %edi,%edi
  802444:	75 0b                	jne    802451 <__umoddi3+0xe9>
  802446:	b8 01 00 00 00       	mov    $0x1,%eax
  80244b:	31 d2                	xor    %edx,%edx
  80244d:	f7 f7                	div    %edi
  80244f:	89 c5                	mov    %eax,%ebp
  802451:	89 f0                	mov    %esi,%eax
  802453:	31 d2                	xor    %edx,%edx
  802455:	f7 f5                	div    %ebp
  802457:	89 c8                	mov    %ecx,%eax
  802459:	f7 f5                	div    %ebp
  80245b:	89 d0                	mov    %edx,%eax
  80245d:	e9 44 ff ff ff       	jmp    8023a6 <__umoddi3+0x3e>
  802462:	66 90                	xchg   %ax,%ax
  802464:	89 c8                	mov    %ecx,%eax
  802466:	89 f2                	mov    %esi,%edx
  802468:	83 c4 1c             	add    $0x1c,%esp
  80246b:	5b                   	pop    %ebx
  80246c:	5e                   	pop    %esi
  80246d:	5f                   	pop    %edi
  80246e:	5d                   	pop    %ebp
  80246f:	c3                   	ret    
  802470:	3b 04 24             	cmp    (%esp),%eax
  802473:	72 06                	jb     80247b <__umoddi3+0x113>
  802475:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802479:	77 0f                	ja     80248a <__umoddi3+0x122>
  80247b:	89 f2                	mov    %esi,%edx
  80247d:	29 f9                	sub    %edi,%ecx
  80247f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802483:	89 14 24             	mov    %edx,(%esp)
  802486:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80248a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80248e:	8b 14 24             	mov    (%esp),%edx
  802491:	83 c4 1c             	add    $0x1c,%esp
  802494:	5b                   	pop    %ebx
  802495:	5e                   	pop    %esi
  802496:	5f                   	pop    %edi
  802497:	5d                   	pop    %ebp
  802498:	c3                   	ret    
  802499:	8d 76 00             	lea    0x0(%esi),%esi
  80249c:	2b 04 24             	sub    (%esp),%eax
  80249f:	19 fa                	sbb    %edi,%edx
  8024a1:	89 d1                	mov    %edx,%ecx
  8024a3:	89 c6                	mov    %eax,%esi
  8024a5:	e9 71 ff ff ff       	jmp    80241b <__umoddi3+0xb3>
  8024aa:	66 90                	xchg   %ax,%ax
  8024ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8024b0:	72 ea                	jb     80249c <__umoddi3+0x134>
  8024b2:	89 d9                	mov    %ebx,%ecx
  8024b4:	e9 62 ff ff ff       	jmp    80241b <__umoddi3+0xb3>
