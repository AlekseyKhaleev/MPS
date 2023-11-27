
// ����

#include <avr/io.h>			// �������� ����������������
#include <avr/interrupt.h>	// ������ � ������������

// ������� ���������� (������� ���������)
uint8_t
	hh=0,hl=0,
	mh=0,ml=0,
	sh=0,sl=0;

// ��������� �������
void dr(uint8_t value);

// ���������� ���������� �� ������������ ������� (������� ������� ��� �������)
ISR(TIMER1_OVF1_vect)
{
	// ���� �������
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
	// ������������� �������
	TCNT1 = 0x0000;
}

// �������� �������
int main(void)
{
	// ��������� ��������� �����
	SPL = RAMEND&0xff;
	//SPH = (RAMEND>>8);
	
	// ��������� ������
	DDRB = 0xff;
	PORTB = 0x01;
	DDRD = 0xff;
	PORTD = 0x00;
	//dr(5);
	
	// ��������� �������
	TCNT0 = 0x0000;
	TCCR1B = 0x02;
	TIMSK = 0x80;
	
	/*hh=1;hl=2;
	mh=3;ml=4;
	sh=5;sl=6;*/
	
	// ���������� ����������
	//sei();
	
	// �������� ���� (��������� �� ���������)
	while(1)
	{
		switch(PORTB&0x3f)
		{
			case 0x01:
				PORTD = 0x00;	// ������� ������
				PORTB = 0x02;	// ����� ����������
				dr(1);			// ������������� � �����
				break;
			case 0x02:
				PORTD = 0x00;	// ������� ������
				PORTB = 0x04;	// ����� ����������
				dr(2);			// ������������� � �����
				break;
			case 0x04:
				PORTD = 0x00;	// ������� ������
				PORTB = 0x08;	// ����� ����������
				dr(3);			// ������������� � �����
				break;
			case 0x08:
				PORTD = 0x00;	// ������� ������
				PORTB = 0x10;	// ����� ����������
				dr(4);			// ������������� � �����
				break;
			case 0x10:
				PORTD = 0x00;	// ������� ������
				PORTB = 0x20;	// ����� ����������
				dr(5);			// ������������� � �����
				break;
			case 0x20:
				PORTD = 0x00;	// ������� ������
				PORTB = 0x01;	// ����� ����������
				dr(0);			// ������������� � �����
				break;
		}
	}
}

// ������������� � ����� �� ���������
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
