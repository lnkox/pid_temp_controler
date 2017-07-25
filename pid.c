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
#define error_led PORTB.0  // індикатор помилки


#define fan PORTB.2 // Вентилятор



#define maxtemp1  800 // Максимальна температура тену (одиниця на 0.0625 градуса)


#define tempmode1  288 // Температура 1-го режиму (одиниця на 0.0625 градуса)
#define tempmode2  352 // Температура 2-го режиму (одиниця на 0.0625 градуса)
#define tempmode3  384 // Температура 3-го режиму (одиниця на 0.0625 градуса)

#include <mega8.h>
// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>

// Declare your global variables here


volatile char delay_pow1=0,delay_pow2=0,delay_pow3=0;
volatile char pow1=0,pow2=0,pow3=0;
volatile int temp1,temp2;
volatile unsigned char res1=0,res2=0;
volatile int error_cnt=0;
volatile int mode_temp=0;
volatile int mode_sem=0;
volatile int power_to_ten=0;

bit pid_frag=0;


int w1_find(void) // Перевірка наявності та скидання пристрою на 1-wire для всіх 4 термодатчиків
{
    int device=0;
    t1_ddr=1; t2_ddr=1;
    t1_port=0; t2_port=0;
    delay_us(485);
    t1_ddr=0; t2_ddr=0;    
    delay_us(65);
    device=device+!t1_port;
    device=device+!t2_port;
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
            t1_ddr=1; t2_ddr=1;
            t1_port=0; t2_port=0;
            delay_us(15);
            t1_port=1;t2_port=1;
            delay_us(50);
            t1_ddr=0;t2_ddr=0;
            delay_us(5);
        }
        else
        { 
            t1_ddr=1; t2_ddr=1; 
            t1_port=0; t2_port=0;
            delay_us(65);
            t1_ddr=0; t2_ddr=0;
            delay_us(5);
        };          
        cmd=cmd>>1;
        };
}


char w1_readbyte() // Читання  байту 1-wire для всіх 4 термодатчиків
{
    unsigned char bitc=0;
    unsigned char res=0; 
    res1=0;res2=0;
    for (bitc=0; bitc < 8; bitc++)
        {
        t1_ddr=1; t2_ddr=1;
        t1_port=0; t2_port=0;
        delay_us(1);
        t1_ddr=0;t2_ddr=0;
        delay_us(14);
        if (t1_pin){res1=res1|(1 << bitc);} 
        if (t2_pin){res2=res2|(1 << bitc);}
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
    unsigned char data[2];
    w1_find();
    w1_send(0xcc);
    w1_send(0xbe);    
    w1_readbyte();
    data[0] = res1; data[1] = res2;
    w1_readbyte();
    temp1 = (res1<<8)| data[0];
    temp2 = (res2<<8)| data[1];
}
void check_mode(void) // Перевірка стану перемикача режимів (Виставлення необхідної температури в кімнаті)
{
    mode_temp=-50;
    if (mode_1==0) mode_temp=tempmode1;
    if (mode_2==0) mode_temp=tempmode2;
    if (mode_3==0) mode_temp=tempmode3; 
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void) // Переривання таймера кожні 0.1мс (задавання інтервалів вмикання семістора для регулювання потужності)
{
    bit p1=0,p2=0,p3=0;
    TCNT0=0x9C;
    if (zero_1==1) delay_pow1=0; 
    if (zero_2==1) delay_pow2=0; 
    if (zero_3==1) delay_pow3=0;
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
TCNT1H=0;
TCNT1L=0;
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



// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Reinitialize Timer2 value
TCNT2=0x06;
// Place your code here


}

void main(void)
{
// Declare your local variables here

int tt1=0,tt2=0;
// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=out 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (1<<DDB0);
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
TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 125,000 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0,52429 s
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
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
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

ds1820_init();
// Global enable interrupts

set_power_ten1(0);
set_power_ten2(0);
set_power_ten3(0);
#asm("sei")


printf("start \n\r");
while (1)
{
      // Place your code here
    if(pid_frag)
    {  
        if (mode_temp>temp2 && temp2!=-1)
        {
            if(temp1<1200 && temp1!=-1)
            {
               if (temp1<maxtemp1)
               {
                 mode_sem=1; // Режим зростання потужності
               }
               else
               {
                 mode_sem=2; // Режим спадання потужності 
               }
            }
            else
            {
                mode_sem=2; // Режим спадання потужності
            } 
        }
        else
        {
            mode_sem=2; // Режим спадання потужності   
        } 
        
        if (mode_sem==1 && power_to_ten<100)
        {
            power_to_ten++;
        }
        
        if (mode_sem==2 && power_to_ten>1)
        {
            power_to_ten=power_to_ten-20;
            if (power_to_ten<0) {power_to_ten=0;}
        }
        
        
        
        
        
        set_power_ten1(power_to_ten);
        set_power_ten2(power_to_ten);
        set_power_ten3(power_to_ten);
        if(temp1>1200 || temp1==-1) error_cnt++;
        if(temp2>1200 || temp2==-1) error_cnt++;  
        if (error_cnt>100) error_led=1;
        printf("err=%i  ", error_cnt);  
        tt1=temp1*0.0625; 
        tt2=temp2*0.0625;
        printf("t1=%i  ",tt1); 
        printf("t2=%i  ",tt2); 
        printf("power_to_ten=%i \n\r",power_to_ten); 
        pid_frag=0;  
        
    }
        
}
}
