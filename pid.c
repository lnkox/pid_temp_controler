#define zero_1 PINB.5 // датчик нуля 1-го тену 
#define zero_2 PINB.4 // датчик нуля 2-го тену
#define zero_3 PINB.3 // датчик нуля 3-го тену

#define sem_1 PORTC.2 // керування 1-им семістором
#define sem_2 PORTC.1 // керування 2-им семістором
#define sem_3 PORTC.0 // керування 3-им семістором


#define mode_0 PIND.2 //перемикач режимів (OFF) 
#define mode_1 PIND.4 //перемикач режимів (1) 
#define mode_2 PIND.3 //перемикач режимів (2) 
#define mode_3 PIND.5 //перемикач режимів (3) 

#define t1_port PORTD.6 // Термодатчик 1
#define t1_pin PIND.6  // Термодатчик 1
#define t1_ddr DDRD.6  // Термодатчик 1
#define t2_port PORTD.7  // Термодатчик 2
#define t2_pin PIND.7 // Термодатчик 2
#define t2_ddr DDRD.7 // Термодатчик 2
#define t3_port PORTB.0  // Термодатчик 3
#define t3_pin PINB.0  // Термодатчик 3
#define t3_ddr DDRB.0  // Термодатчик 3
#define t4_port PORTB.1 // Термодатчик 4
#define t4_pin PINB.1  // Термодатчик 4
#define t4_ddr DDRB.1  // Термодатчик 4

#define fan PORTB.2 // Вентилятор


#define K_P     0.20
#define K_I     0.00
#define K_D     0.00

#define maxtemp1  800 // Максимальна температура 1-го тену (одиниця на 0.0625 градуса)
#define maxtemp2  800 // Максимальна температура 2-го тену (одиниця на 0.0625 градуса)
#define maxtemp3  800 // Максимальна температура 3-го тену (одиниця на 0.0625 градуса)

#define tempmode1  288 // Температура 1-го режиму (одиниця на 0.0625 градуса)
#define tempmode2  352 // Температура 2-го режиму (одиниця на 0.0625 градуса)
#define tempmode3  384 // Температура 3-го режиму (одиниця на 0.0625 градуса)

#include <mega328.h>
// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>
#include "pidlib.h"

// Declare your global variables here


volatile char delay_pow1=0,delay_pow2=0,delay_pow3=0;
volatile char pow1=0,pow2=0,pow3=0;
volatile int temp1,temp2,temp3,temp4;
volatile unsigned char res1=0,res2=0,res3=0,res4=0;
volatile int error_cnt=0;
volatile int mode_temp=0;
struct PID_DATA pidData1;
bit pid_frag=0;

void Init_pid(void) // Ініціалізація ПІД
{
    pid_Init(K_P * SCALING_FACTOR, K_I * SCALING_FACTOR , K_D * SCALING_FACTOR , &pidData1);
}
int w1_find(void) // Перевірка наявності та скидання пристрою на 1-wire для всіх 4 термодатчиків
{
    int device=0;
    t1_ddr=1; t2_ddr=1; t3_ddr=1; t4_ddr=1; 
    t1_port=0; t2_port=0; t3_port=0; t4_port=0;
    delay_us(485);
    t1_ddr=0; t2_ddr=0; t3_ddr=0; t4_ddr=0;   
    delay_us(65);
    device=device+!t1_port;
    device=device+!t2_port;
    device=device+!t3_port;
    device=device+!t4_port;
	delay_us(420);
	return device;
}

void w1_send(char cmd) // відправка  байту 1-wire для всіх 4 термодатчиків
{
    unsigned char bitc=0; 
    for (bitc=0; bitc < 8; bitc++)
     {
        if (cmd&0x01) // сравниваем младший бит
        {  
            t1_ddr=1; t2_ddr=1; t3_ddr=1; t4_ddr=1;
            t1_port=0; t2_port=0; t3_port=0; t4_port=0;
            delay_us(15);
            t1_port=1;t2_port=1;t3_port=1;t4_port=1;
            delay_us(50);
            t1_ddr=0;t2_ddr=0;t3_ddr=0;t4_ddr=0;
            delay_us(5);
        }
        else
        { 
            t1_ddr=1; t2_ddr=1; t3_ddr=1; t4_ddr=1;
            t1_port=0; t2_port=0; t3_port=0; t4_port=0;
            delay_us(65);
            t1_ddr=0; t2_ddr=0; t3_ddr=0; t4_ddr=0;
            delay_us(5);
        };          
        cmd=cmd>>1;
        };
}


char w1_readbyte() // Читання  байту 1-wire для всіх 4 термодатчиків
{
    unsigned char bitc=0;
    unsigned char res=0; 
    res1=0;res2=0;res3=0;res4=0;
    for (bitc=0; bitc < 8; bitc++)
        {
        t1_ddr=1; t2_ddr=1; t3_ddr=1; t4_ddr=1;
        t1_port=0; t2_port=0; t3_port=0; t4_port=0;
        delay_us(1);
        t1_ddr=0;t2_ddr=0;t3_ddr=0;t4_ddr=0;
        delay_us(14);

        if (t1_pin){res1=res1|(1 << bitc);} 
        if (t2_pin){res2=res2|(1 << bitc);}
        if (t3_pin){res3=res3|(1 << bitc);}
        if (t4_pin){res4=res4|(1 << bitc);}
        delay_us(45); 
        };
        delay_us(5);
    return res;
}
void send_start_measurement(void) // Відправка команди початку вимірювання температури для всіх 4 термодатчиків
{
    w1_find();
    w1_send(0xcc);  // пропустить ром
    w1_send(0x44);
}
void ds1820_init(void) // ініціалізація всіх 4 термодатчиків 
{
    w1_find();  
    w1_send(0xcc);  // пропустить ром
    w1_send(0x4e); // команда записи в датчик
    w1_send(0x32); // верхняя граница термостата th
    w1_send(0); // нижняя граница термостата tlow
    w1_send(0x1f); // режим работы - 9 бит
}
void read_temp(void) // Читання температури всіх 4 термодатчиків
{
    unsigned char data[4];
    w1_find();
    w1_send(0xcc);
    w1_send(0xbe);    
    w1_readbyte();
    data[0] = res1; data[1] = res2; data[2] = res3;  data[3] = res4;
    w1_readbyte();
    temp1 = (res1<<8)| data[0];
    temp2 = (res2<<8)| data[1];
    temp3 = (res3<<8)| data[2];
    temp4 = (res4<<8)| data[3];
   // printf("temp1=%i  ",temp1);  
   // printf("temp2=%i  ",temp2); 
   // printf("temp3=%i  ",temp3); 
   // printf("temp4=%i \n\r",temp4); 
    

}
void check_mode(void) // Перевірка стану перемикача режимів (Виставлення необхідної температури в кімнаті)
{
    mode_temp=-50;
    if (mode_1==0) mode_temp=tempmode1;
    if (mode_2==0) mode_temp=tempmode2;
    if (mode_3==0) mode_temp=tempmode3; 
}
interrupt [PC_INT0] void pin_change_isr0(void) // Переривання при зміні стану будь якого з трьох датчиків нуля (оновлення відповідного лічильника інтервалу)
{
    if (zero_1==1) delay_pow1=0; 
    if (zero_2==1) delay_pow2=0; 
    if (zero_3==1) delay_pow3=0; 
}
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void) // Переривання таймера кожні 0.1мс (задавання інтервалів вмикання семістора для регулювання потужності)
{
    bit p1=0,p2=0,p3=0;
    TCNT0=0x9C;
    if ( delay_pow1<105 ) delay_pow1++;
    if ( delay_pow2<105 ) delay_pow2++;
    if ( delay_pow3<105 ) delay_pow3++;
    if (delay_pow1==pow1) p1=1;
    if (delay_pow2==pow2) p2=1;
    if (delay_pow3==pow3) p3=1;
    sem_1=p1;sem_2=p2;sem_3=p3;
      
}

interrupt [TIM1_OVF] void timer1_ovf_isr(void) // Переривання таймера кожні 100мс (вимір температури, перевірка стану перемикача режимів)
{
// Reinitialize Timer1 value
TCNT1H=0xCF2C >> 8;
TCNT1L=0xCF2C & 0xff;
     #asm("cli")
    read_temp();
    send_start_measurement();
    check_mode();
    pid_frag=1;          
    delay_pow1=0; 
    delay_pow2=0; 
    delay_pow3=0;         
     #asm("sei") 
}
void set_power_ten1(int power) // Встановлення вихідної потужності для тена 1
{
    if (power>99) power=99;
    if (power>5) { pow1=100-power;} else {pow1=110;}
}
void set_power_ten2(int power) // Встановлення вихідної потужності для тена 2
{
    if (power>99) power=99;
    if (power>5) { pow2=100-power;} else {pow2=110;}
}
void set_power_ten3(int power) // Встановлення вихідної потужності для тена 3
{
    if (power>99) power=99;
    if (power>5) { pow3=100-power;} else {pow3=110;}
}
void main(void)
{
// Declare your local variables here
int power_to_ten1, power_to_ten2, power_to_ten3;

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1000,000 kHz
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
// Timer Period: 0,1 ms
TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (1<<CS01) | (0<<CS00);
TCNT0=0x9C;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 125,000 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0,5 s
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
TCNT1H=0x0B;
TCNT1L=0xDC;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2A output: Disconnected
// OC2B output: Disconnected
ASSR=(0<<EXCLK) | (0<<AS2);
TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (1<<TOIE1);

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: On
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EIMSK=(0<<INT1) | (0<<INT0);
PCICR=(0<<PCIE2) | (0<<PCIE1) | (1<<PCIE0);
PCMSK0=(0<<PCINT7) | (0<<PCINT6) | (1<<PCINT5) | (1<<PCINT4) | (1<<PCINT3) | (0<<PCINT2) | (0<<PCINT1) | (0<<PCINT0);
PCIFR=(0<<PCIF2) | (0<<PCIF1) | (1<<PCIF0);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART0 Mode: Asynchronous
// USART Baud Rate: 9600
UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
ADCSRB=(0<<ACME);
// Digital input buffer on AIN0: On
// Digital input buffer on AIN1: On
DIDR1=(0<<AIN0D) | (0<<AIN1D);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// 1 Wire Bus initialization
// 1 Wire Data port: PORTD
// 1 Wire Data bit: 5
// Note: 1 Wire port settings are specified in the
// Project|Configure|C Compiler|Libraries|1 Wire menu.

ds1820_init();
// Global enable interrupts

set_power_ten1(0);
set_power_ten2(0);
set_power_ten3(0);
#asm("sei")


  Init_pid();
printf("start \n\r");
while (1)
{
      // Place your code here
    if(pid_frag)
    {  
        if (mode_temp>temp4)
        {
            if(temp1<1200 && temp1!=-1)
            {
                power_to_ten1 = pid_Controller(maxtemp1,temp1, &pidData1);
            }
            else
            {
                power_to_ten1=0;   
            } 
        }
        else
        {
            power_to_ten1=0;power_to_ten2=0;power_to_ten3=0;    
        }
        set_power_ten1(power_to_ten1);
        set_power_ten2(power_to_ten2);
        set_power_ten3(power_to_ten3);
        if(temp1>1200 || temp1==-1) error_cnt++;
        if(temp2>1200 || temp2==-1) error_cnt++;  
        if(temp3>1200 || temp3==-1) error_cnt++;  
        if(temp4>1200 || temp4==-1) error_cnt++; 
        printf("err=%i  ", error_cnt);   
        printf("mV=%i  ",temp1); 
        printf("oV=%i \n\r",power_to_ten1); 
        pid_frag=0;
    }
        
}
}
