/*
 * @Author: LiZedong <15516926476@163.com>
 * @Date: 2022-04-01 10:14:25
 * @LastEditTime: 2022-04-01 11:36:44
 * @LastEditors: LiZedong <15516926476@163.com>
 * @Description: 
 */
void io_hlt(void);
void write_mem8(int addr, int data);


void HariMain(void)
{
	int i; /* �ϐ��錾�Bi�Ƃ����ϐ��́A32�r�b�g�̐����^ */
	for (i = 0xa0000; i <= 0xaffff; i++) {
		// write_mem8(i, i%16);
		char *p = i;
		*p = i % 16;
		// printf(&p);
	}

	for (;;) {
		io_hlt();
	}
}
