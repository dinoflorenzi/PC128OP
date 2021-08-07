#include<stdlib.h>
#include<stdio.h>
unsigned int sum=0;
unsigned char chk=0;
unsigned short l;
int nblock;
int rest;
int cnt=0;
int frmt( char * ptr, char size,char* out)
{
	memset(out,0x20,11);
	char * point=".";
	int k=0,i=0;
		int p=strcspn(ptr,point);
		if(p==size-1||p>8||size>12||p==0)
		{
			printf("incompatible string\nplease use *******.*** format\n");
			return -1;
		}
		for(i=0;i<size;i++)
		{
			if(i==p)
			k+=(8-p);
			else
			{
		      out[k]=ptr[i];
		      k++;
			}
			
		}
		return 0;
}

void swapen(unsigned short *num)
{
unsigned short swapped;
swapped = (*num>>8) | (*num<<8);
*num=swapped;
}

void crc ( unsigned char * data, int l,unsigned int   * old)
{ 

   cnt+=l;
	for (int i= 0;i<l;i++)
	{
	(*old)+=data[i];

	}
}

unsigned char cmpl(unsigned int n)
{
	return 0x100- ((unsigned char)n);
}

int main(int argc,char *argv[])
{
	if(argc==1)
	{
		printf("Missing arguments !!!!!!\n"
		"bin2k7 source pc128_filename K7_filename\n"
		"load and exec address is set to &H0000.\n"
		"Use offset to load to any address. EX: LOADM\"CASS:\",&H6000 will load starting to &H6000\n"
		);
		return -1;
	}
	unsigned short start=0;
	unsigned short size;
	unsigned short runaddr=0;
	FILE *fr,*fw;
	char nome[12];
	char nomecod[12];
	char source[20];
	char destin[100];
		fr=fopen(argv[1],"rb");
	if(!fr) 
	{	
		printf("source file not found!!!!");
		return -1;
	}

	if(frmt(argv[2],strlen(argv[2]),nome))
	{
			return -1;
	}
	

	unsigned char byt;
	unsigned short l;
	unsigned char h[]={1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0x3c,0x5a};
    unsigned char h1[]={1,0,0};
    unsigned char h2[]={1,0};
	unsigned char n[]={0x00,0x10};
	unsigned char n1[]={0x02,0x00,0x00};
	unsigned char end[]={0xff,0x02,0x00};
	unsigned char z=0;
	unsigned char u=1;
	unsigned char preend[]={0xff,0x00,0x00};
	fr=fopen(argv[1],"rb");
	if(argv[3]==NULL)
	{
		strcpy(destin,argv[1]);
		strcat(destin,".K7");
	}
	else
	strcpy(destin,argv[3]);
	fw=fopen(destin,"wb");
	fseek(fr, 0L, SEEK_END);
    size = ftell(fr);
    l=size;
    nblock=floor((size+12)/254);
    printf("n blocks: %d\n",nblock);
    printf("size: %d\n",size);
    rest=size+12-nblock*254;
    
    rewind(fr);
    swapen(&size);
    swapen(&start);
    swapen(&runaddr);
	fwrite(&h,sizeof(h),1,fw);
	fwrite(&n,sizeof(n),1,fw);
	fwrite(&nome,sizeof(nome)-1,1,fw);
	fwrite(&n1,3,1,fw);
	crc(nome,11,&sum);
	crc(&n1,1,&sum);
	
	chk=cmpl(sum);
	sum=0;
	cnt=0;
	fwrite(&chk,1,1,fw);
	fwrite(&h,sizeof(h),1,fw);
	if(nblock>0)
	{
	fwrite(&h1,sizeof(h1),1,fw);
	}
	else
	{
			fwrite(&u,sizeof(u),1,fw);
	        fwrite(&rest,1,1,fw);
	        fwrite(&z,sizeof(z),1,fw);
	}
	cnt++;
	fwrite(&size,sizeof(size),1,fw);
	fwrite(&start,sizeof(start),1,fw);
	crc(&size,sizeof(size),&sum);
	crc(&start,sizeof(start),&sum);
	for (int i=0;i<l;i++)
	{
		if(cnt>253)
		{
			nblock--;
			chk=cmpl(sum);
			sum=0;
			//printf("%d\n",chk);
	    	fwrite(&chk,1,1,fw);
			fwrite(&h,sizeof(h),1,fw);
			if(nblock>0)
			fwrite(&h2,sizeof(h2),1,fw);
			else
			{
					fwrite(&u,sizeof(u),1,fw);
				    fwrite(&rest,1,1,fw);
				    printf("*****\n");
			}
			cnt=0;
		    
		}
		fread(&byt,1,1,fr);
		crc(&byt,1,&sum);
		fwrite(&byt,1,1,fw);
	}
		crc(&preend,3,&sum);
		fwrite(&preend,3,1,fw);
		crc(&runaddr,2,&sum);
		fwrite(&runaddr,2,1,fw);
		chk=cmpl(sum);
		sum=0;
		fwrite(&chk,1,1,fw);
		fwrite(&h,sizeof(h),1,fw);
		fwrite(&end,sizeof(end),1,fw);
		printf("chk %x rest %x block %d\n",chk,rest,nblock);
		
	fclose(fr);
	fclose(fw);
	
	return 0;
}
