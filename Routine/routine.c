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

#define g1_on TIMSK|=0x10
#define g2_on TIMSK|=0x08

#define g1_off TIMSK&=0xEF
#define g2_off TIMSK&=0xF7

#define forward PORTB|=0x10 //PORTB4=1
#define backward PORTB&=0xEF //PORTB4=0

unsigned int PAUSE=10000; //디스펜서까지의 거리
unsigned int ENDLINE=20000; //끝까지의 스텝수 저장 상수
unsigned int ONE=400; //한 알  스텝 수 저장 상수
unsigned int NEXT=100; //약통의 다음칸으로 이동할 스텝수 저장 상수

unsigned int step1=0; //디스펜서의 현재 스텝 저장 변수
unsigned int step2=0; //이동모터의 현재 스텝 저장 변수
unsigned int target=0;
unsigned int position=0; //현재 위치
unsigned char fin=0; 

unsigned char txdata=0; //시리얼 통신의 송신데이터 저장 변수
unsigned char rxdata=0; //시리얼 통신의 수신데이터 저장 변수
unsigned char pill0[3]={0,0,0}; //[현재 몇 알 줬는지, 한번에 몇 알, 하루에 몇 번] 순으로 저장
unsigned char pill1[3]={0,0,0};
unsigned char pill2[3]={0,0,0};
unsigned char unit[3]={0,0,0}; //[약 종류, 한 번에 몇 알, 하루에 몇 번] 순으로 저장
unsigned char index=0;

unsigned int g1=2500;  //speed
unsigned int g2=2500;


interrupt [TIM1_COMPA] void timer1_compa_isr(void)      
{
    step1++;
    if(step1==ONE)
    {
        m0_off;
        m1_off;
        m2_off;  
        g1_off; //disable ocie1a
        step1=0;
        fin=1;
    }  
}

interrupt [TIM1_COMPB] void timer1_compb_isr(void)      
{
    step2++;   
    if(step2==target) 
    {
        m3_off;
        g2_off; //disable ocie1b 
        position+=step2;
        step2=0; 
        fin=1;
    }
}
void vel_f5()
{
    OCR1AH=(g1>>8);
    OCR1AL=g1;
    OCR1BH=(g2>>8); 
    OCR1BL=g2;
}
void transmit() //after setting txdata
{
     UCSR0B |= 0x20;
     delay_ms(30); //300
}  
void beep(){
     //buzzer on
    delay_ms(300);
     //buzzer off 
     txdata='e';
     transmit();
}
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
    for(i=0; i<3; i++)
    {
        pill0[i]=0;
        pill1[i]=0;
        pill2[i]=0;
    }
}
void motor(char num)
{
    fin=0;
    switch(num)
    {
        case 0:
            m0_on;
            g1_on;
            break;
        case 1:
            m1_on;
            g1_on;
            break;
        case 2:
            m2_on;
            g1_on;
            break;
        case 3:
            m3_on;
            g2_on;
            break;
    }
}
void give0() //timer1a
{
    motor(0); 
    for(pill0[0]=0;pill0[0]<=pill0[1];pill0[0]++)      //[한번에 먹는 약만큼]
    { 
        while(fin==0);  //스텝수에 도달할 때까지 delay 
    }    
}  

void give1()
{
    motor(1);  
    for(pill1[0]=0;pill1[0]<=pill1[1];pill1[0]++)
    {
        while(fin==0);
    }
} 

void give2() 
{
    motor(2); 
    for(pill2[0]=0;pill2[0]<=pill2[1];pill2[0]++)
    {
        while(fin==0);
    }
} 

void go(unsigned int t)
{  
    target=t;
    motor(3);
    while(fin==0);
}


char str2int(char str){ //시리얼 통신의 char data 변환
    if(str=='1') return 1;
    else if(str=='2') return 2;
    else if(str=='3') return 3;
}

void BTinit(void)
{
    UCSR0A=0x00;
    UCSR0B=0x98;
    UCSR0C=0x06;
    UBRR0H=0;
    UBRR0L=103;
}

void run(){
    char days, meals;
    forward;
    go(PAUSE); 
    
    for(days=0; days<2;days++)//약을 며칠 복용하는지에 따라 다르게 수행
    { 
        pill0[0]=0; //날짜에 따라 주는 약 개수 초기화
        pill1[0]=0;
        pill2[0]=0;
        for(meals=1; meals<=3; meals++) //아침,점심,저녁 약을 [하루 복용수]에 맞게
        {  
            if (meals<=pill0[2]) give0();  //하루에 몇번 넣었는지가 [하루 복용횟수] 보다 적거나 같을 경우 실행
            if (meals<=pill1[2]) give1();
            if (meals<=pill2[2]) give2();
            forward;
            go(NEXT); //다음칸으로 이동
        }
    }
    forward;
    go(ENDLINE-position);
    beep(); 
    delay_ms(1000);
    backward;
    go(ENDLINE); //back to start point

}

interrupt [USART0_RXC] void usart0_rxc(void) //수신
{
    rxdata=UDR0;
    //UCSR0B |= 0x20;
    //UDRE=1 USCR0B = 0b10111000 = 송신허용 
    
    if(rxdata=='s')
    {
        init();
        index=0;
    }
    else if(rxdata=='e')
    { 
        run();
    } 
    else if(rxdata=='a' || rxdata=='b' || rxdata=='c')
    {
        unit[index]=rxdata;
        index++;
    }
    else if(rxdata=='0' || rxdata=='1' || rxdata=='2')
    {
        unit[index]=rxdata; 
        index++;
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
        }
    }
    
}

interrupt [USART0_DRE] void usart0_dre(void)  //송신하고 나서 송신 금지.
{
    UDR0=txdata;
    UCSR0B &= 0xDF; // UDRE = 0 USCR0B = 0b10011000
}



void main(void)
{
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

    }
}
