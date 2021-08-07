#include<stdio.h>
int main(void)
{
	
	char infile[30];
	char outfile[30];
	printf("input file name (.k7): ");
	scanf("%s",infile);
	printf("output file name : ");
	scanf("%s",outfile);
	FILE *in;
	FILE *out;
	in=fopen(infile,"rb");
	out=fopen(outfile,"wb");
	fseek(in, 0L, SEEK_END);
	int len=ftell(in);
	int pos =0x36;
	int blklen;
	unsigned char byt,byt2;
	int nb=(len-0x37)/(253+20);
	fseek(in, pos, SEEK_SET);
	//printf("%d\n",len);
	while(pos<len)
	{
	fread(&byt,1,1,in);
	if(byt==0)
	blklen=254;
	else
	blklen=byt-2;
	//printf("%d\n",blklen);
	for(int i=0;i<blklen;i++)
	{
		fread(&byt,1,1,in);
		if(byt!=0x16)
		{
		fwrite(&byt,1,1,out);
		}
		else
		{
			fread(&byt,1,1,in);
			fread(&byt2,1,1,in);
			i+=2;
			if(byt==0x41&&byt2==0x61)
			byt=0xe0;  
			if(byt==0x43&&byt2==0x61)
			byt=0xe2;
			if(byt==0x4b&&byt2==0x63)
			byt=0xe7;
			if(byt==0x41&&byt2==0x65)
			byt=0xe8;
			if(byt==0x42&&byt2==0x65)
			byt=0xe9;
			if(byt==0x43&&byt2==0x65)
			byt=0xea;
			if(byt==0x48&&byt2==0x65)
			byt=0xeb;
			if(byt==0x43&&byt2==0x69)
			byt=0xee;
			if(byt==0x48&&byt2==0x69)
			byt=0xef;
			if(byt==0x43&&byt2==0x6f)
			byt=0xf4;
			if(byt==0x48&&byt2==0x6f)
			byt=0xf6;
			if(byt==0x41&&byt2==0x75)
			byt=0xf9;
			if(byt==0x43&&byt2==0x75)
			byt=0xfb;
			if(byt==0x48&&byt2==0x75)
			byt=0xfc;
			fwrite(&byt,1,1,out);
			
		}
		
		printf("%c",byt);
		if(byt==0x0d)
		{
			byt=0x0a;
		    fwrite(&byt,1,1,out);
		    printf("%c",byt);
		}
		
	}
	if(blklen==254)
	fseek(in,20L,SEEK_CUR);
	else
	fseek(in,0L,SEEK_END);
	pos=ftell(in);
	//printf("%d\n",blklen);
	}
	fclose(in);
	fclose(out);
	return 0;
}