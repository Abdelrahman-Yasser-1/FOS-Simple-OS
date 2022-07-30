 #include <inc/lib.h>

// malloc()
//	This function use FIRST FIT strategy to allocate space in heap
//  with the given size and return void pointer to the start of the allocated space

//	To do this, we need to switch to the kernel, allocate the required space
//	in Page File then switch back to the user again.
//
//	We can use sys_allocateMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls allocateMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the allocateMem function is empty, make sure to implement it.

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
struct info{
		void* str_address;
		void* end_address;
		int pages;
		int isFree;
};

#define numPages ((USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE)

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
		spaces[0].end_address = (void*)USER_HEAP_MAX;
		spaces[0].pages = numPages;
		spaces[0].isFree = 1;
		arraySize++;
	}
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;

		if(spaces[i].pages >= reqPages)
		{
			if(min_diff > spaces[i].pages - reqPages)
			{
				min_diff = spaces[i].pages - reqPages;
				index = i;
			}
		}

	}

	if(index == -1 )
	{
		return NULL;
	}

	else
	{
		if(reqPages == spaces[index].pages)
		{
			spaces[index].isFree = 0;
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
			spaces[arraySize].end_address = spaces[index].end_address;
			spaces[arraySize].pages = spaces[index].pages-reqPages;
			spaces[arraySize].isFree = 1;
			arraySize++;

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
			spaces[index].pages = reqPages;
			spaces[index].isFree = 0;
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
		}
		return spaces[index].str_address;
	}


}

// free():
//	This function frees the allocation of the given virtual_address
//	To do this, we need to switch to the kernel, free the pages AND "EMPTY" PAGE TABLES
//	from page file and main memory then switch back to the user again.
//
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].str_address == virtual_address)
		{
			index=i;
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
			break;
		}

	}

	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;

		if(spaces[index].str_address == spaces[i].end_address)
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
			spaces[i].pages += spaces[index].pages;

			//remove from spaces
			spaces[index].str_address = 0;
			spaces[index].end_address = 0;
			spaces[index].pages = -1;
			spaces[index].isFree = 0;
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;

		if(spaces[index].end_address == spaces[i].str_address)
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
			spaces[i].pages += spaces[index].pages;

			//remove from spaces
			spaces[index].str_address = 0;
			spaces[index].end_address = 0;
			spaces[index].pages = -1;
			spaces[index].isFree = 0;
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
	{
		spaces[index].isFree = 1;
	}

}

//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
	panic("this function is not required...!!");
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
	panic("this function is not required...!!");
	return 0;
}

void sfree(void* virtual_address)
{
	panic("this function is not required...!!");
}

void *realloc(void *virtual_address, uint32 new_size)
{
	panic("this function is not required...!!");
	return 0;
}

void expand(uint32 newSize)
{
	panic("this function is not required...!!");
}
void shrink(uint32 newSize)
{
	panic("this function is not required...!!");
}

void freeHeap(void* virtual_address)
{
	panic("this function is not required...!!");
}
