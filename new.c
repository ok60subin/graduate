#include <delay.h>
#include <mega128.h>
#include <stdio.h>



#define s_on PORTE=(0<<PORTE3) 
#define s_off PORTE=(1<<PORTE3)
#define a_on PORTB=(0<<PORTB5)
#define a_off PORTB=(1<<PORTB5)
#define b_on PORTB=(0<<PORTB6)
#define b_off PORTB=(1<<PORTB6)
#define c_on PORTB=(0<<PORTB7)
#define c_off PORTB=(1<<PORTB7)

#define forward PORTA=(1<<PORTA3)
#define backward PORTA=(0<<PORTA3)


#define BEEP 
unsigned int step2=0; //이동모터의 현재 스텝 저장 변수
unsigned int step1=0; //디스펜서의 현재 스텝 저장 변수
unsigned int position=0; //현재 위치
unsigned int dposition=0;

unsigned int PAUSE=10000; //디스펜서까지의 거리
unsigned int ENDLINE=20000; //끝까지의 스텝수 저장 상수
unsigned int ONE=400; //한바퀴 스텝 수 저장 상수
unsigned int NEXT=50; //약통의 다음칸으로 이동할 스텝수 저장 상수

unsigned int txdata=0; //시리얼 통신의 송신데이터 저장 변수
unsigned char rxdata=0; //시리얼 통신의 수신데이터 저장 변수
unsigned char rxdata_p=0; //시리얼 통신의 이전 수신데이터 저장 변수
unsigned char howA[3]=[0,0,0]; //[한번에 몇 알, 하루에 몇 번, 현재 몇 알 줬는지] 순으로 저장
unsigned char howB[3]=[0,0,0];
unsigned char howC[3]=[0,0,0];
unsigned char unit[3]=[0,0,0]; //[약 종류, 한 번에 몇 알, 하루에 몇 번] 순으로 저장


interrupt [TIM3_COMPA] void timer3_compa_isr(void)      
{
    step2=(step2++)>>1;  //스텝수를 증가시키고 반으로 나누어 저장
}
interrupt [TIM1_COMPA] void timer1_compa_isr(void)      
{
    step1=(step1)>>1;
}

void beep(){
    PORTE=(1<<PORTE7); //buzzer on
    delay_ms(300);
    PORTE=(0<<PORTE7); //buzzer off
}
void init(){
    txdata=0;
    rxdata=0;
    rxdata_p=0;
    step2=0;
    step1=0;
    howA=[0,0,0]; 
    howB=[0,0,0];
    howC=[0,0,0];
}

void GivingA() //timer1a
{
    if(howA[2]<=howA[0]){ //[한번에 먹는 약만큼]
        step1=0;
        a_on;
        while(step1<ONE);  //스텝수에 도달할 때까지 delay
    }
    a_off;
    howA[2]=0;
}  

void GivingB() //timer1b
{
    while(howB[2]<=howB[0]){
        step1=0;
        b_on;
        while(step1<ONE);
    }
    b_off;
    howB[2]=0;
} 

void GivingC() //timer1c
{
    while(howC[2]<=howC[0]){
        step1=0;
        c_on;
        while(step1<ONE);
    }
    c_off;
    howC[2]=0;
} 

void go(int howstep)
{
    forward;
    step2=0;
    s_on;
    while(step2<howstep);
    s_off;
    position+=step2;

}

void back()
{
    backward;
    step2=0;
    s_on;
    while(step2<ENDLINE);
    s_off;
    position-=step2;

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

void transmit() //after setting txdata
{
     UCSR0B |= 0x20;
     delay_ms(300);
}  

void run(){
    go(PAUSE);
    for(char days=0; days<2;days++)//약을 며칠 복용하는지에 따라 다르게 수행
    { 
        howA[2]=0; //날짜에 따라 주는 약 개수 초기화
        howB[2]=0;
        howC[2]=0;
        for(char meals=0; meals<2; meals++) //아침,점심,저녁 약을 [하루 복용수]에 맞게
        {  
            if (meals+1<=howA[1]) givingA();  //하루에 몇번 넣었는지가 [하루 복용횟수] 보다 적거나 같을 경우 실행
            if (meals+1<=howB[1]) givingB();
            if (meals+1<=howC[1]) givingC();
            go(NEXT); //다음칸으로 이동
        }
    }
    go(ENDLINE-position);
    beep();
    back();

}

interrupt [USART0_RXC] void usart0_rxc(void) //수신
{
    rxdata=UDR0;
    //UCSR0B |= 0x20;
    //UDRE=1 USCR0B = 0b10111000 = 송신허용 
    if(rxdata_p=='s'){ //시작신호
        unit[0]=rxdata; //단위 0자리에 [무슨 약인지] 저장
    }
    else if(rxdata_p=='a'|| rxdata_p=='b' || rxdata_p=='c' ){
        unit[1]=rxdata; //[무슨 약인지] 저장되고 난 후의 데이터는 [한번에 몇 번인지] 자리에 저장
    }
    else if (rxdata_p=='1'||rxdata_p=='2'||rxdata_p=='3') //이전에 들어온게 숫자일 때 > [약 종류] or [하루에 몇 번인지]
    {
        if(unit[2]==0){  //[하루에 몇 번인지] 자리가 비어있을 때
            unit[2]=rxdata;  //[하루에 몇 번인지] 저장 후 약 배열에 정보 배분
            if(unit[0]=='a'){
                howA[0]=unit[1];
                howA[2]=unit[2];
            }
            else if(unit[0]=='b'){
                howB[0]=unit[1];
                howB[2]=unit[2];
            }
            else if(unit[0]=='b'){
                howC[0]=unit[1];
                howC[2]=unit[2];
            }
            unit=[0,0,0]; //저장마디 초기화
            
        }
        else{ //[하루에 몇 번인지] 자리가 차있으면 다음 약 종류 저장
            unit[0]=rxdata;
        }
    }
    
    if(rxdata=='s'){
        init();
    }
    else if(rxdata=='e'){ 
        run();
    }
    rxdata_p=rxdata;  
}

interrupt [USART0_DRE] void usart0_dre(void)  //송신하고 나서 송신 금지.
{
    UDR0=txdata;
    UCSR0B &= 0xDF; // UDRE = 0 USCR0B = 0b10011000
}


/*

STEP  EN    DIR   TIM     MOTOR
PB5 - PC0 - PA0 - OC1a - A motor
PB6 - PC1 - PA1 - OC1b - B motor
PB7 - PC2 - PA2 - OC1c - C motor
PE3 - PC3 - PA3 - OC3a - Moving motor

PE7 > buzzer
PE0 > RX
PE1 > TX


tccr1a= a1a0 b1b0 c1c0 00  x1x0 > 10 =toggle 00= gpio
*/

void main(void)
{
    TCCR3A=0x00;
    TCCR3B=0x0A;
    TCCR1A=0x00;
    TCCR1B=0x0A;
    TIMSK=0x18  // 00011000
    ETIMSK=0x11; //00010001 timer1 ,timer3 ctc interrupt enable
    DDRE=0b10000010; //7: buzzer 1:txd0 0:rxd0  
    DDRC=0x0F;
    DDRA=0x0F;
    SREG=0x80;
    BTinit();
    OCR1AH=0x0A;
    OCR1AL=0x00; 
    OCR1BH=0x0A;
    OCR1BL=0x00;
    OCR1CH=0x0A;
    OCR1CL=0x00;
    OCR3AH=0xAA;
    OCR3AL=0x00;
    init();

    while(1){

    }
}
