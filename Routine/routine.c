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

#define forward PORTB|=0x10 //PORTB4=1
#define backward PORTB&=0xEF //PORTB4=0

#define buzzer_on  PORTA|=0x10 //PORTA4=1      0001 0000
#define buzzer_off  PORTA&=0xEF //PORTA4=0      1110 1111
#define buzzer_t PORTA^=0x10

unsigned int PAUSE=20000; //디스펜서까지의 거리
unsigned int ENDLINE=48000; //끝까지의 스텝수 저장 상수
unsigned int ONE=6000; //한 알  스텝 수 저장 상수
unsigned int NEXT=2000; //약통의 다음칸으로 이동할 스텝수 저장 상수

unsigned int step1=0; //디스펜서의 현재 스텝 저장 변수
unsigned int step2=0; //이동모터의 현재 스텝 저장 변수

unsigned char start=0;
unsigned int where2=0;
unsigned int target=0;
unsigned int position=0; //현재 위치

unsigned int txdata=0; //시리얼 통신의 송신데이터 저장 변수
unsigned char rxdata=0; //시리얼 통신의 수신데이터 저장 변수
unsigned char pill0[3]={0,0,0}; //[현재 몇 알 줬는지, 한번에 몇 알, 하루에 몇 번] 순으로 저장
unsigned char pill1[3]={0,0,0};
unsigned char pill2[3]={0,0,0};
unsigned char unit[3]={0,0,0}; //[약 종류, 한 번에 몇 알, 하루에 몇 번] 순으로 저장
unsigned char index=0;

unsigned int sp1=1400;
unsigned int sp2=1400; 

void init(){
    unsigned char i;
    txdata=0;
    rxdata=0; 
    step1=0;
    step2=0;
    m0_off;
    m1_off;
    m2_off;
    m3_off;
    g1_off;
    g2_off; 
    index=0;
    for(i=0; i<3; i++)
    {
        pill0[i]=0;
        pill1[i]=0;
        pill2[i]=0;
    }
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
void string(char *str)
{   
    unsigned int i=0;
    for(i=0; str[i]; i++)
    {
        txdata=str[i];
        transmit(); 
        delay_ms(10);
    }
}
void beep(unsigned int n){
    buzzer_on;
    delay_ms(n);
    buzzer_off;
}
void vel_f5()
{
    OCR1AH=(sp1>>8);
    OCR1AL=sp1;
    OCR1BH=(sp2>>8); 
    OCR1BL=sp2;  
}

void wait(unsigned int t)
{
    t*=3;
    t/=4;
    delay_ms(t);
}
void motor0()
{
    m0_on;
    g1_on; 
}
void motor1()
{
    m1_on;
    g1_on;  
}
void motor2()
{
    m2_on;
    g1_on; 
    
}
void motor3()
{
    m3_on;
    g2_on; 
}
void give0() //timer1a
{
    for(pill0[0]=0;pill0[0]<pill0[1];pill0[0]++)      //[한번에 먹는 약만큼]
    {             
        motor0();
        wait(ONE); 
    }    
}  

void give1()
{ 
    for(pill1[0]=0;pill1[0]<pill1[1];pill1[0]++)
    {             
       motor1();     
       wait(ONE); 
    }
} 

void give2() 
{
    for(pill2[0]=0;pill2[0]<pill2[1];pill2[0]++)
    {            
         motor2();    
         wait(ONE); 
    }
} 

void go(unsigned int t)
{  
    target=t;     
    motor3(); 
    wait(t);
}

char str2int(char str){ //시리얼 통신의 char data 변환
    if(str=='1') return 1;
    else if(str=='2') return 2;
    else if(str=='3') return 3;
    else if(str=='0') return 0;
}

void run(){
    unsigned char days=0;
    unsigned char meals=1;
    forward;  
    go(PAUSE); 
   for(days=0; days<2;days++)//약을 며칠 복용하는지에 따라 다르게 수행
    {   
        for(meals=1; meals<=3; meals++) //아침,점심,저녁 약을 [하루 복용수]에 맞게
        {  
            if (meals<=pill0[2]) give0();  //하루에 몇번 넣었는지가 [하루 복용횟수] 보다 적거나 같을 경우 실행
            if (meals<=pill1[2]) give1();
            if (meals<=pill2[2]) give2();
            forward;
            beep(500);
            go(NEXT); //다음칸으로 이동 
        }
        delay_ms(100); 
        beep(500);
    }  
    forward;
    go(ENDLINE-position); 
    
    backward;
    go(ENDLINE); //back to start point
    start=0;    

}

interrupt [USART0_RXC] void usart0_rxc(void) //수신
{
    rxdata=UDR0;
    switch (rxdata)
    {      
        case 'x':
            m0_t;
            break;
        case 'y':
            m3_t;
            break;   
        case 'z':
            buzzer_t;
            break;
        case 's':
            init(); 
            string("1");
            break;
        case 'e':
            string("5");
            start=1;
            break; 
        case 'a':
        case 'b':
        case 'c':  
            unit[index]=rxdata;
            index++; 
            string("2");
            break;
        case '0':
        case '1':
        case '2':
        case '3':
            unit[index]=rxdata; 
            index++;  
            string("3");
            if(index==3)
            {
                index=0; 
                switch(unit[0])
                {
                    case 'a' :
                        pill0[1]=str2int(unit[1]);
                        pill0[2]=str2int(unit[2]);
                        break;
                    case 'b' :
                        pill1[1]=str2int(unit[1]);
                        pill1[2]=str2int(unit[2]);
                        break;
                    case 'c':
                        pill2[1]=str2int(unit[1]);
                        pill2[2]=str2int(unit[2]);
                        break;
                }
                string("4");
             }
             break;
    }
}

interrupt [TIM1_COMPA] void timer1_compa_isr(void)      
{
    step1++;
    if(step1>=ONE)
    {
        m0_off;
        m1_off;
        m2_off;  
        g1_off; //disable ocie1a    
        step1=0;
    }  
}
interrupt [TIM1_COMPB] void timer1_compb_isr(void)      
{
    step2++;   
    if(step2>=target) 
    {
        m3_off;
        g2_off; //disable ocie1b 
        position+=step2;
        step2=0; 
    }
}

interrupt [USART0_DRE] void usart0_dre(void)  
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
    DDRE=0b00000010; // 1:txd0 0:rxd0  
    DDRB=0xFF;   //3,4: dir 5,6: step
    DDRA=0x1F;  
    SREG=0x80;
    TCCR1A=0x50; //TIMER1a, TIMER1b on Timer1c off
    TCCR1B=0x0A; 
    TCCR1C=0x00;     
    OCR1AL=0x00;
    OCR1AH=0x00;
    OCR1BL=0x00;
    OCR1BH=0x00; 
    OCR1CH=0x00;
    OCR1CL=0x00;
    TCNT1H=0x00;
    TCNT1L=0x00;
    TIMSK=0x00;  //0001 1000 OCIE1A, OCIE1B interrupt enable
    ETIMSK=0x00;
    
    init();
    BTinit();
    vel_f5(); 
    
    while(1){ 
        if(start==1) run();
    }
}
