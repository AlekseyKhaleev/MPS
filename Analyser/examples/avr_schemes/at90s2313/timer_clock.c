
// Часы

#include <avr/io.h>			// Описание микроконтроллера
#include <avr/interrupt.h>	// Работа с прерываниями

// Часовые переменные (часовые шестерёнки)
uint8_t
	hh=0,hl=0,
	mh=0,ml=0,
	sh=0,sl=0;

// Прототипы функций
void dr(uint8_t value);

// Обработчик прерывания по переполнению таймера (часовая пружина или маятник)
ISR(TIMER1_OVF1_vect)
{
	// Счёт времени
	if ((++sl) >= 10)
	{
		sl=0;
		/*if ((++sh) >= 6)
		{
			sh=0;
			if ((++ml) >= 10)
			{
				ml=0;
				if ((++mh) >= 6)
				{
					mh=0;
					if ((++hl) >= 10)
					{
						if ((hour>>4) >= 2)
						{
							hour = 0;
						}
						hh++;
					}
				}
			}
		}*/
	}
	dr(sl);
	// Корректировка таймера
	TCNT1 = 0x0000;
}

// Основная функция
int main(void)
{
	// Настройка указателя стека
	SPL = RAMEND&0xff;
	//SPH = (RAMEND>>8);
	
	// Настройка портов
	DDRB = 0xff;
	PORTB = 0x01;
	DDRD = 0xff;
	PORTD = 0x00;
	//dr(5);
	
	// Настройка таймера
	TCNT0 = 0x0000;
	TCCR1B = 0x02;
	TIMSK = 0x80;
	
	/*hh=1;hl=2;
	mh=3;ml=4;
	sh=5;sl=6;*/
	
	// Разрешение прерываний
	//sei();
	
	// Основной цикл (циферблат со стрелками)
	while(1)
	{
		switch(PORTB&0x3f)
		{
			case 0x01:
				PORTD = 0x00;	// Очистка данных
				PORTB = 0x02;	// Смена индикатора
				dr(1);			// Декодирование и вывод
				break;
			case 0x02:
				PORTD = 0x00;	// Очистка данных
				PORTB = 0x04;	// Смена индикатора
				dr(2);			// Декодирование и вывод
				break;
			case 0x04:
				PORTD = 0x00;	// Очистка данных
				PORTB = 0x08;	// Смена индикатора
				dr(3);			// Декодирование и вывод
				break;
			case 0x08:
				PORTD = 0x00;	// Очистка данных
				PORTB = 0x10;	// Смена индикатора
				dr(4);			// Декодирование и вывод
				break;
			case 0x10:
				PORTD = 0x00;	// Очистка данных
				PORTB = 0x20;	// Смена индикатора
				dr(5);			// Декодирование и вывод
				break;
			case 0x20:
				PORTD = 0x00;	// Очистка данных
				PORTB = 0x01;	// Смена индикатора
				dr(0);			// Декодирование и вывод
				break;
		}
	}
}

// Декодирование и вывод на индикатор
void dr(uint8_t value)
{
	switch(value)
	{
		case 0:
			PORTD = 0x3f;
			break;
		case 1:
			PORTD = 0x06;
			break;
		case 2:
			PORTD = 0x5b;
			break;
		case 3:
			PORTD = 0x4f;
			break;
		case 4:
			PORTD = 0x66;
			break;
		case 5:
			PORTD = 0x6d;
			break;
		case 6:
			PORTD = 0x7d;
			break;
		case 7:
			PORTD = 0x07;
			break;
		case 8:
			PORTD = 0x7f;
			break;
		case 9:
			PORTD = 0x6f;
			break;
	}
}
