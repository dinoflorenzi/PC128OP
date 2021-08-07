#include<stdlib.h>
#include<stdio.h>
unsigned int sum=0;
unsigned char chk=0;
unsigned short l;
int nblock,nb;
int rest,rest2;
int cnt=0;
FILE *fr,*fw;
int frmt( char * ptr, char size,char* out)
{
	memset(out,32,11);
	char * point=".";
	int k=0;
		int p=strcspn(ptr,point);
		if(p==size-1||p>8||size>12||p==0)
		{
			printf("incompatible string\nplease use *******.*** format\n");
			return -1;
		}
		for(int i=0;i<size;i++)
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
	return 0x100u - ((unsigned char)n);
}
void writeAcc(unsigned char c1,unsigned char c2)
{
    unsigned char c=0x16;
    crc(&c,1,&sum);
	fwrite(&c,1,1,fw);
	crc(&c1,1,&sum);
	fwrite(&c1,1,1,fw);
	crc(&c2,1,&sum);
	fwrite(&c2,1,1,fw);
	rest+=2;
}
int main()
{
	char buffer[20];
	unsigned short start;
	unsigned short size;
	unsigned short runaddr;
	
	char nome[12];
	char nomecod[12];
	char source[20];
	char dest[20];
	printf("txt file source: ");
	fgets(buffer,sizeof(buffer),stdin);
	if(buffer[0]==10)
	strcpy(buffer,"test.asm");
	sscanf(buffer,"%s",source);
	printf("dest k7 file name: ");
	fgets(buffer,sizeof(buffer),stdin);
	if(buffer[0]==10)
	strcpy(buffer,"gioco.k7");
	sscanf(buffer,"%s",dest);
fr=fopen(source,"rb");
	if(!fr) return -1;
	printf("Nome file (max 8): ");
	fgets(buffer,sizeof(buffer),stdin);
	if(buffer[0]==10)
	strcpy(buffer,"test    .bin");
	sscanf(buffer,"%12s",nomecod);
		//printf("start address: ");
		//fgets(buffer,sizeof(buffer),stdin);
	if(buffer[0]==10)
	strcpy(buffer,"0000");
	sscanf(buffer,"%d",&start);
	//	printf("exec address: ");
	//	fgets(buffer,sizeof(buffer),stdin);
	if(buffer[0]==10)
	strcpy(buffer,"0000");
	sscanf(buffer,"%d",&runaddr);
	if(frmt(nomecod,strlen(nomecod),nome))
	return -1;

	unsigned char byt;
	unsigned short l;
	unsigned char h[]={1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0x3c,0x5a};
    unsigned char h1[]={1,0,0};
    unsigned char h2[]={1,0};
	unsigned char n[]={0x00,0x10};
	unsigned char n1[]={0x00,0xff,0xff};
	unsigned char end[]={0xff,0x02,0x00};
	unsigned char z=0;
	unsigned char u=1;
	unsigned char preend[]={0xff,0x00,0x00};
	fr=fopen(source,"rb");
	fw=fopen(dest,"wb");
	if(fw==NULL) return 1;
	fseek(fr, 0L, SEEK_END);
    size = ftell(fr);
    l=size;
    nblock=(int)((size)/253);
    nb=nblock;
    printf("n blocks: %d\n",nblock);
    printf("size: %d\n",size);
    rest=size-nblock*253+2;
    printf("%d resto\n",rest2);
    rewind(fr);
    swapen(&size);
    swapen(&start);
    swapen(&runaddr);
	fwrite(&h,sizeof(h),1,fw);
	fwrite(&n,sizeof(n),1,fw);
	fwrite(&nome,sizeof(nome)-1,1,fw);
	fwrite(&n1,3,1,fw);
	crc(nome,11,&sum);
	crc(&n1,3,&sum);
	
	chk=cmpl(sum);
	sum=0;
	cnt=0;
	fwrite(&chk,1,1,fw);
	fwrite(&h,sizeof(h),1,fw);
	if(nblock>0)
	{
	fwrite(&h2,sizeof(h2),1,fw);
	}
	else
	{
			fwrite(&u,sizeof(u),1,fw);
	        fwrite(&rest,1,1,fw);
	}

	for (int i=0;i<l;i++)
	{
		if(cnt>253)
		{
			nblock--;
			rest--;
			chk=cmpl(sum);
			sum=0;
			printf("%d %x %x\n",nblock,chk,rest);
	    	fwrite(&chk,1,1,fw);
			fwrite(&h,sizeof(h),1,fw);
			if(nblock>0)
			fwrite(&h2,sizeof(h2),1,fw);
			else
	       {
					fwrite(&u,sizeof(u),1,fw);
				    fwrite(&rest,1,1,fw);
				
			}
			cnt=0;
			
		    
		}
		fread(&byt,1,1,fr);
		
		switch(byt)
		{
		    case 0xe0:
		    writeAcc(0x41,0x61);
		    break;
		    case 0xe2:
		    writeAcc(0x43,0x61);
		    break;
		    case 0xe7:
		    writeAcc(0x4b,0x63);
		    break;
		    case 0xe8:
		    writeAcc(0x41,0x65);
		    break;
		    case 0xe9:
		    writeAcc(0x42,0x65);
		    break;
		    case 0xea:
		    writeAcc(0x43,0x65);
		    break;
		    case 0xeb:
		    writeAcc(0x48,0x65);
		    break;
		    case 0xee:
		    writeAcc(0x43,0x69);
		    break;
		    case 0xef:
		    writeAcc(0x48,0x69);
		    break;
		    case 0xf4:
		    writeAcc(0x43,0x6f);
		    break;
		    case 0xf6:
		    writeAcc(0x48,0x6f);
		    break;
		    case 0xf9:
		    writeAcc(0x41,0x75);
		    break;
		    case 0xfc:
		    writeAcc(0x48,0x75);
		    break;
		    default:
		    
		    if(byt==0x0a) byt=0x0d;
	    	crc(&byt,1,&sum);
	    	fwrite(&byt,1,1,fw);
		    break;
		}
		
	}
		chk=cmpl(sum);
		sum=0;
		fwrite(&chk,1,1,fw);
		fwrite(&h,sizeof(h),1,fw);
		fwrite(&end,sizeof(end),1,fw);
		printf("chk %d\n",chk);
		
	fclose(fr);
	fclose(fw);
	
	return 0;
}
