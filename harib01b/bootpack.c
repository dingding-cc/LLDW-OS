/*
 * @Author: LiZedong <15516926476@163.com>
 * @Date: 2022-04-01 10:14:25
 * @LastEditTime: 2022-04-01 18:56:22
 * @LastEditors: LiZedong <15516926476@163.com>
 * @Description: 
 */
void io_hlt(void);
void write_mem8(int addr, int data);


void HariMain(void)
{
	int i; /* �ϐ��錾�Bi�Ƃ����ϐ��́A32�r�b�g�̐����^ */
	char *p;
	p = 0xa0000;
	for (i = 0; i <= 0xffff; i++) {
		// write_mem8(i, i%16);
		p[i] = i % 16;
		// printf(&p);
	}

	for (;;) {
		io_hlt();
	}
}
