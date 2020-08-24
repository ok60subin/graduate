#include <delay.h>
#include <mega128.h>
#include <stdio.h>

#define m0_on PORTA&=0xFE
#define m1_on PORTA&=0xFD
#define m2_on PORTA&=0xFB
#define m3_on PORTA&=0xF7

#define m0_off PORTA|=0x01
#define m1_off PORTA|=0x02
#define m2_off PORTA|=0x04
#define m3_off PORTA|=0x08

#define m0_t PORTA^=0x01
#define m1_t PORTA^=0x02
#define m2_t PORTA^=0x04
#define m3_t PORTA^=0x08

#define g1_on TIMSK|=0x10
#define g2_on TIMSK|=0x08

#define g1_off TIMSK&=0xEF
#define g2_off TIMSK&=0xF7

#define g1_ccw PORTB&=0xF7
#define g2_ccw PORTB&=0xEF

#define g1_cw PORTB|=0x08
#define g2_cw PORTB|=0x10

#define g1_t PORTB^=0x08
#define g2_t PORTB^=0x10


unsigned char txdata=0; //시리얼 통신의 송신데이터 저장 변수
unsigned char rxdata=0; //시리얼 통신의 수신데이터 저장 변수

unsigned int g1=2500;  //속
unsigned int g2=2500;

unsigned int step1=0;
unsigned int end1=800;
unsigned int step2=0;
unsigned int end2=2000;

unsigned char left=0;
unsigned char mid=0;
unsigned char right=0;

void init()
{
    m0_off;  
    m1_off;
    m2_off;
    m3_off;
    step1=0;
    step2=0;
}
void BTinit(void)
{
    UCSR0A=0x00;
    UCSR0B=0x98;
    UCSR0C=0x06;
    UBRR0H=0;
    UBRR0L=103;
}

void transmit() //after setting txdata
{
     UCSR0B |= 0x20;
     delay_ms(10);
}
unsigned char* dec(int data)
{
    unsigned char i;
    unsigned char sdata[10]={'0','0','0','0','0','0','0','0','0','0'}; 
    unsigned char tdata[10]={0,0,0,0,0,0,0,0,0,0};
    for(i=0;i<4;i++)
    {
        sdata[i]=(data % 10)+ '0';
        data/=10;
        if (data==0) break;
    }
    for(i=0;i<10;i++)
    { 
        tdata[i]=sdata[3-i];  
    }
    
    return tdata;
}  
void string(char *str)
{   
    unsigned int i=0;
    for(i=0; str[i]; i++)
    {
        txdata=str[i];
        transmit();
    }
}
void vel_f5()
{
    OCR1AH=(g1>>8);
    OCR1AL=g1;
    OCR1BH=(g2>>8); 
    OCR1BL=g2;
}

void adj_end1(){
    string(dec(end1));
    while (left==0){
        if(mid==1){
            end1+=100;
            mid=0;
            string(dec(end1));
        } 
        if(right==1){
            end1-=100;
            right=0;
            string(dec(end1));
        }
    } 
    left=0;
}
void adj_end2(){
    string(dec(end2));
    while (left==0){
        if(mid==1){
            end2+=100;
            mid=0;
            string(dec(end2));
        } 
        if(right==1){
            end2-=100;
            right=0;
            string(dec(end2));
        }
    } 
    left=0;
}
void speed1(){
    string(dec(g1));
    while (left==0){
        if(mid==1){
            g1+=100;
            mid=0;
            string(dec(g1));
        } 
        if(right==1){
            g1-=100;
            right=0;
            string(dec(g1));
        }
    }
    vel_f5();
    left=0;
}
void speed2(){
    string(dec(g2));
    while (left==0){
        if(mid==1){
            g2+=100;
            mid=0;
            string(dec(g2));
        } 
        if(right==1){
            g2-=100;
            right=0;
            string(dec(g2));
        }
    } 
    vel_f5();
    left=0;
}
interrupt [TIM1_COMPA] void timer1_compa_isr(void)      
{
    step1++;
    if(step1==end1)
    {
        m0_off;
        m1_off;
        m2_off;  
        g1_off; //disable ocie1a
        step1=0;
    }  
}
/*
interrupt [TIM1_COMPB] void timer1_compb_isr(void)      
{
    step2++;   
    if(step2==end2) 
    {
        m3_off;
        g2_off; //disable ocie1b
        step2=0;
    }
}
*/
interrupt [USART0_RXC] void usart0_rxc(void) //수신
{
    rxdata=UDR0; 
    switch (rxdata)
    {
        case '0':
            left=1;
            break;
        case '1':
            mid=1;
            break;
        case '2':
            right=1;
            break;
        case '3':
            g1_cw;
            break;
        case '4':
            g1_ccw;
            break;
        case '5':
            g2_cw;
            break;
        case '6':
            g2_ccw;
            break;
        case '7':
            g1+=100;
            vel_f5();
            break;
        case '8':
            g1-=100;
            vel_f5();
            break;
        case '9':
            g2+=100;
            vel_f5();
            break;
        case 'a':
            g2-=100;
            vel_f5();
            break; 
        
    }
}

interrupt [USART0_DRE] void usart0_dre(void)  //송신하고 나서 송신 금지.
{
    UDR0=txdata;
    UCSR0B &= 0xDF; // UDRE = 0 USCR0B = 0b10011000
}


/*

    M        STEP    EN      DIR     TIM 
    0        PB5     PA0     PB3     OC1a
    1        PB5     PA1     PB3     OC1a
    2        PB5     PA2     PB3     OC1a
    3        PB6     PA3     PB4     OC1b 


*/

void main(void)
{
    unsigned char max=7;
    signed char menu=0;
    DDRE=0b10000010; //7: buzzer 1:txd0 0:rxd0  
    DDRB=0b01111000;   //3,4: dir 5,6: step
    DDRA=0x0F;  
    SREG=0x80;
    TCCR1A=0x50; //TIMER1a, TIMER1b on Timer1c off
    TCCR1B=0x0A; 
    OCR1AL=0x00;
    OCR1AH=0x00;
    OCR1BL=0x00;
    OCR1BH=0x00;
    TCNT1H=0x00;
    TCNT1L=0x00;
    TIMSK=0x00;  //0001 1000 OCIE1A, OCIE1B interrupt enable
    
    init();
    BTinit();
    vel_f5(); 
    
    while(1){
          if (menu<0) menu=max;
          if (menu>max) menu=0;
          switch (menu)
          {
            case 0:
                string("M0");
                while(mid==0)
                {
                    if(left==1)
                    {
                        left=0;
                        m0_t;
                        g1_on;
                    }
                    if(right==1)
                    {
                        menu-=2;
                        right=0;
                        break;
                    }
                    
                }
                menu++;
                mid=0;
                break;  
            case 1:
                string("M1");
                while(mid==0)
                {
                    if(left==1)
                    {   
                        left=0; 
                        m1_t;
                        g1_on;
                    }
                    if(right==1)
                    {
                        menu-=2;
                        right=0;
                        break;
                    }
                    
                }
                menu++;
                mid=0;
                break;
            case 2:
                string("M2");
                while(mid==0)
                {
                    if(left==1)
                    {  
                        left=0;
                        m2_t;
                        g1_on;
                    }
                    if(right==1)
                    {
                        menu-=2;
                        right=0; 
                        break;
                    }
                    
                }
                menu++;
                mid=0;
                break;   
            case 3:
                string("M3");
                while(mid==0)
                {
                    if(left==1)
                    {    
                        left=0;
                        m3_t;
                        //g2_on;
                    }
                    if(right==1)
                    {
                        menu-=2;
                        right=0;
                        break;
                    }
                    
                }
                menu++;
                mid=0;
                break;  
                
            case 4:
                string("E1");
                while(mid==0)
                {
                    if(left==1)
                    {
                        left=0;
                        adj_end1();
                    }
                    if(right==1)
                    {
                        menu-=2;
                        right=0;
                        break;
                    }
                    
                }
                menu++;
                mid=0;
                break; 
            case 5:
                string("S1");
                while(mid==0)
                {
                    if(left==1)
                    {
                        left=0;
                        speed1();
                    }
                    if(right==1)
                    {
                        menu-=2;
                        right=0;
                        break;
                    }
                    
                }
                menu++;
                mid=0;
                break; 
            case 6: 
                string("E2");
                while(mid==0)
                {
                    if(left==1)
                    {
                        left=0; 
                        adj_end2();
                    }
                    if(right==1)
                    {
                        menu-=2;
                        right=0;
                        break;
                    }
                    
                }
                menu++;
                mid=0;
                break;
            case 7:
                string("S2");
                while(mid==0)
                {
                    if(left==1)
                    {
                        left=0;
                        speed2();
                    }
                    if(right==1)
                    {
                        menu-=2;
                        right=0;
                        break;
                    }
                    
                }
                menu++;
                mid=0;
                break;  
                /*
            case x: 
                string("메뉴이름");
                while(mid==0)
                {
                    if(left==1)
                    {
                        left=0; 
                        메뉴진입();
                    }
                    if(right==1)
                    {
                        menu-=2;
                        right=0;
                        break;
                    }
                    
                }
                menu++;
                mid=0;
                break; 
                */
          }
    }
}
/*
void 함수이름(){
    while (left==0){
        if(mid==1){
            
        } 
        if(right==1){
        
        } 
    left=0;
}

*/