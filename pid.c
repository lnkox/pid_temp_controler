#define zero_1 PINB.5
#define zero_2 PINB.4
#define zero_3 PINB.3

#define sem_1 PORTC.2
#define sem_2 PORTC.1
#define sem_3 PORTC.0

#define tsens_1 5
#define tsens_2 6
#define tsens_3 7
#define tsens_port PORTD

#define mode_0 PIND.5
#define mode_1 PIND.4
#define mode_2 PIND.3
#define mode_3 PIND.2

#define t1_port PORTD.6
#define t1_pin PIND.6
#define t1_ddr DDRD.6
#define t2_port PORTD.7
#define t2_pin PIND.7
#define t2_ddr DDRD.7
#define t3_port PORTB.0
#define t3_pin PINB.0
#define t3_ddr DDRB.0
#define t4_port PORTB.1
#define t4_pin PINB.1
#define t4_ddr DDRB.1

#define fan PORTB.2

#include <mega328.h>
// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>

// Declare your global variables here
volatile char delay_pow1=0,delay_pow2=0,delay_pow3=0;
volatile char pow1=0,pow2=0,pow3=0;
volatile int temp1,temp2,temp3,temp4;

int w1_find(void)
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

void w1_send(char cmd)
{
    unsigned char bitc=0; 
    #asm("cli") // запрещаем прерывания, что бы не было сбоев при передачи
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
        cmd=cmd>>1; //сдвигаем передаваемый байт данных на 1 в сторону младших разрядов
        };
    #asm("sei")
}


char w1_readbyte(char n_ter)
{
    unsigned char bitc=0;// счетчик принятых байт
    unsigned char res=0; // принятый байт
    #asm("cli")

    for (bitc=0; bitc < 8; bitc++)
        {
        t1_ddr=1; t2_ddr=1; t3_ddr=1; t4_ddr=1;
        t1_port=0; t2_port=0; t3_port=0; t4_port=0;
        delay_us(1);
        t1_ddr=0;t2_ddr=0;t3_ddr=0;t4_ddr=0;
        delay_us(14);     // ждем завершения переходных процессов

        if (t1_pin && n_ter==1){res=res|(1 << bitc);} 
        if (t2_pin && n_ter==2){res=res|(1 << bitc); }
        if (t3_pin && n_ter==3)                      
        { 
            res=res|(1 << bitc);
        };
        if (t4_pin && n_ter==4)                      
        { 
            res=res|(1 << bitc);
        };
        delay_us(45); // ждем до завершения тайм слота
        };
        delay_us(5);
    #asm("sei")
    return res;
}
void send_start_measurement(void)
{
 
    if (w1_find()==4)
    { 
       w1_send(0xcc);  // пропустить ром
       w1_send(0x44);
    } 


}
void ds1820_init(void)
{
    w1_find();  
    w1_send(0xcc);  // пропустить ром
    w1_send(0x4e); // команда записи в датчик
    w1_send(0x32); // верхняя граница термостата th
    w1_send(0); // нижняя граница термостата tlow
    w1_send(0x1f); // режим работы - 9 бит
}
void read_temp(void)
{
    unsigned char data[2];
    int temp = 0;
    w1_find();//снова посылаем Presence и Reset
    w1_send(0xcc);
    w1_send(0xbe);//передать байты ведущему(у 18b20 в первых двух содержится температура)
    data[0] = w1_readbyte(1);
    data[1] = w1_readbyte(1);
    temp = data[1];
    temp = temp<<8;
    temp |= data[0];
    temp1=temp* 0.0625;
     w1_find();//снова посылаем Presence и Reset
    w1_send(0xcc);
    w1_send(0xbe); 
    data[0] = w1_readbyte(2);
    data[1] = w1_readbyte(2);
    temp = data[1];
    temp = temp<<8;
    temp |= data[0];
    temp2=temp* 0.0625;
     w1_find();//снова посылаем Presence и Reset
    w1_send(0xcc);
    w1_send(0xbe);
    data[0] = w1_readbyte(3);
    data[1] = w1_readbyte(3);
    temp = data[1];
    temp = temp<<8;
    temp |= data[0];
    temp3=temp* 0.0625; 
     w1_find();//снова посылаем Presence и Reset
    w1_send(0xcc);
    w1_send(0xbe);
    data[0] = w1_readbyte(4);
    data[1] = w1_readbyte(4);
    temp = data[1];
    temp = temp<<8;
    temp |= data[0];
    temp4=temp* 0.0625;
    printf("temp1=%i  ",temp1);  
    printf("temp2=%i  ",temp2); 
    printf("temp3=%i  ",temp3); 
    printf("temp4=%i \n\r",temp4); 
    

}
interrupt [PC_INT0] void pin_change_isr0(void)
{
    if (zero_1==1) delay_pow1=0; 
    if (zero_2==1) delay_pow2=0; 
    if (zero_3==1) delay_pow3=0; 
}
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    bit p1=0,p2=0,p3=0;
    TCNT0=0x9C;
    if ( delay_pow1<100 ) delay_pow1++;
    if ( delay_pow2<100 ) delay_pow2++;
    if ( delay_pow3<100 ) delay_pow3++;
    if (delay_pow1==pow1) p1=1;
    if (delay_pow2==pow2) p2=1;
    if (delay_pow3==pow3) p3=1;
    sem_1=p1;sem_2=p2;sem_3=p3;
      
}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Reinitialize Timer1 value
TCNT1H=0xBDC >> 8;
TCNT1L=0xBDC & 0xff;

    read_temp();
    send_start_measurement();
   
         

}

void main(void)
{
// Declare your local variables here

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
#asm("sei")


pow1=20;
pow2=50;
pow3=90;
printf("start \n\r");
while (1)
      {
      // Place your code here

      }
}
