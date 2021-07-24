#include<stdio.h>
#include<math.h>
char scrput[]={  0x30, 0x8d, 0x00, 0x71, 0xa6, 0x80, 0x27, 0x3e, 0x10, 0xef, 0x8d, 0x00, 0x66, 0x86, 0x02, 0x34, 0x02, 0x10, 0x8e, 0x00, 0x00, 0xb6, 0xa7, 0xc0, 0x8a, 0x01, 0xb7, 0xa7, 0xc0, 0xa6, 0x80, 0xe6, 0x80, 0xa7, 0xa0, 0x10, 0x8c, 0x1f, 0x41, 0x27, 0x05, 0x5a, 0x26, 0xf5, 0x20, 0xef, 0x10, 0x8e, 0x00, 0x00, 0xb6, 0xa7, 0xc0, 0x84, 0xfe, 0xb7, 0xa7, 0xc0, 0x6a, 0xe4, 0x26, 0xdf, 0x35, 0x02, 0x10, 0xee, 0x8d, 0x00, 0x2e, 0x39, 0x10, 0x8e, 0x00, 0x00, 0xb6, 0xa7, 0xc0, 0x8a, 0x01, 0xb7, 0xa7, 0xc0, 0xa6, 0x80, 0xa7, 0xa0, 0x10, 0x8c, 0x1f, 0x40, 0x26, 0xf6, 0x10, 0x8e, 0x00, 0x00, 0xb6, 0xa7, 0xc0, 0x84, 0xfe, 0xb7, 0xa7, 0xc0, 0xa6, 0x80, 0xa7, 0xa0, 0x10, 0x8c, 0x1f, 0x40, 0x26, 0xf6, 0x39, 0x00, 0x00 };
int len;
unsigned char cmp=0;
unsigned char * header_data=NULL;
unsigned char * header_data_cmap=NULL;
unsigned char mem[16000];
char filename1[100],filename2[100],filename3[100],filename4[100];
void rgb2bgr12(int);
int compress(unsigned char *);
unsigned int width,height;
void scr320x200x16(void);
void scr320x200x4(void);
void scr160x200x16(void);
int main(int argc,char *argv[])
{
   if(argc==1)
   {
       printf("usage:\n"
              "im2pc128 scrmode inputfile asm\n"
              "scrmode: 2 for 320x200 4 colors\n"
              "scrmode: 3 for 160x200 16 colors\n"
              "inputfile: gimp2 .data exported picture\n"
              "asm: with asm option the binary include asm code picture loader\n"
              );
   return 1;
   }
	int scrmode=atoi(argv[1]);
    FILE *in1=NULL;
	FILE *in2=NULL;
    strcpy(filename1,argv[2]);
    printf("screenmode %d\n",scrmode);
    
    strcpy(filename2,filename1);
    strcpy(filename3,filename1);
    strcat(filename3,".bin");
    strcat(filename2,".pal");
    strcpy(filename4,filename2);
    strcat(filename4,".txt");
    
    printf("opening %s\n",filename1);
    in1=fopen(filename1,"rb");
    if(in1==NULL)
    {
        printf("error missing file .data");
        return 1;
    }
    printf("opening %s\n",filename2);
    in2=fopen(filename2,"rb");
       if(in2==NULL)
    {
        printf("error missing file .data.pal");
        return 1;
    }
    
    fseek(in1,0L,SEEK_END);
    int size1=ftell(in1);
    fseek(in1,0L,SEEK_SET);
    
    fseek(in2,0L,SEEK_END);
    int size2=ftell(in2);
    fseek(in2,0L,SEEK_SET);
    //printf("size1 %d\n",size1);
    //printf("size2 %d\n",size2);
    if(size1!=32000)
    {
        printf(".data file size not compatible (32000 bytes needed)\n");
        return 1;
    }
    unsigned char* buffer1=(unsigned char*)malloc(size1);
    unsigned char* buffer2=(unsigned char*)malloc(size2);
    fread(buffer1,size1,1,in1);
    fread(buffer2,size2,1,in2);
    
    fclose(in1);
    fclose(in2);
    
    header_data=buffer1;
    header_data_cmap=buffer2;
    FILE *out=NULL;
    out=fopen(filename3,"wb");
   
    if(buffer1==NULL||buffer2==NULL)return 1;
    switch (scrmode)
    {
        case 0:
        scr320x200x16();
        case 2:
        scr320x200x4();
        break;
        case 3:
        scr160x200x16();
        break;
    }

    
    if(argc==4)
    if(strcmp(argv[3],"asm")==0)
    fwrite(scrput,sizeof(scrput),1,out);
    fwrite(&cmp,1,1,out);
    fwrite(mem,len,1,out);
    fclose(out);
    printf("generated bin file: %s\n",filename3);
    len++;
    if(argc==4)
    if(strcmp(argv[3],"asm")==0)
    len+=sizeof(scrput);
    printf("lenght %d bytes\n",len);
    return 0;
}

void scr320x200x16()
{
}
void scr320x200x4()
{
	printf("320x200x4");
	width=320;
    height=200;
    rgb2bgr12(4);
    
    int size=height*width;
    int index=0;
    int i,b;
    for(i=0;i<size;i+=8)
    {
        unsigned char byte1=0;
        unsigned char byte2=0;
       unsigned char pixel; 
        
        for(b=0;b<8;b++)
        {
          pixel=header_data[i+b];
          unsigned char esp=pow(2,(7-b));
          if(pixel==2)
          byte1+=esp;
          if(pixel==1)
          byte2+=esp;
          if(pixel==3)
          {
              byte1+=esp;
              byte2+=esp;
          }
         
          
        }
        //printf("%x %x %x \n",index,byte1,byte2);
        mem[index]=byte1;
        mem[index+8000]=byte2;
        index++;
    }
 len=compress(mem);
}


void scr160x200x16()
{
    rgb2bgr12(16);
    width=160;
    height=200;
    int size=height*width;
    int index=0;
    unsigned char byte1=0;
    unsigned char byte2=0;
    int i;
    for(i=0;i<size;i+=4)
    {
        byte1=header_data[i+1]+(header_data[i]<<4);
        byte2=header_data[i+3]+(header_data[i+2]<<4);
        mem[index]=byte1;
        mem[index+8000]=byte2;
        index++;
    }
 len=compress(mem);
}

unsigned short gamma(unsigned char c)
{
   // return c>>4;
	int i,col=0;
	int ef_vals[16]={0,60,90,110,130,148,165,180,193,205,215,225,230,235,240,255};

	   for (i=0;i<15;i++)
	   {
	   		if((c>=ef_vals[i])&&(c<ef_vals[i+1])) return i;
	   }
	   return 15;
}

void rgb2bgr12(int ncol)
{
        //BGR
       
        int i;
     FILE *pal=NULL;
    pal=fopen(filename4,"w");
     
    for(i=0;i<ncol*3;i+=3)
    {

    unsigned short r=(gamma(header_data_cmap[i]))&0x000f;
    unsigned short
    g=((gamma(header_data_cmap[i+1]))&0x000f)<<4;
    unsigned short b=(gamma(header_data_cmap[i+2])&0x000f)<<8;
    unsigned short color=r+g+b;

    //printf("%d - %x  \n",i,color);
    fprintf(pal,"%d PALETTE %d,&H%x \r\n",(i/3+1)*10,i/3,color);
    
    }
      fclose(pal);
      printf("generated palette basic code in file:  %s\n",filename4);
}
    

int compress(unsigned char * bufferin)
{
    unsigned char b;
    int index=0;
    unsigned char bufferout[16000];
        unsigned char oldb=bufferin[0];
        int i,count =1;
    for(i=0;i<8000;i++)
    {
        b=bufferin[i];       
        if(b==oldb&&count<256)
        count++;
        else
        {
        bufferout[index]=oldb;
        bufferout[index+1]=count;
        count=1;
        index+=2;
        }
        oldb=b;
    }
    bufferout[index]=oldb;
    bufferout[index+1]=count;
    
    oldb=bufferin[8000];
    count =1;
    index+=2;
    
    for(i=8000;i<16000;i++)
    {
        b=bufferin[i];
        if(b==oldb&&count<256)
        count++;
        else
        {
            bufferout[index]=oldb;
        bufferout[index+1]=count;
        count=1;
        index+=2;
        }
        oldb=b;
        
    }
    bufferout[index]=oldb;
    bufferout[index+1]=count;
    index++;
    cmp=0;
    index=16999;
    if(index<16000)
    {
    for(i=0;i<index;i++)
    bufferin[i]=bufferout[i];
    cmp=1;
    }
    else
    index=16000;
    return index;
}
