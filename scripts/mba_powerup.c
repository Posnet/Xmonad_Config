/*
*
* A Random Hacker - MacBook Air SuperDrive enabler
* No guarantee
* The MBA SuperDrive needs 1100mA supply from the host USB Port
* No promises if you ignore this.
*
* This is a first attempt - I don’t think the enabler packet is
optimal
* It could probably be improved - but hey I just wanted to prove a
point.
*
* BTW - the firmware on the ATA->USB bridge board can be rewritten
* You would then be able to have this fix applied permanently.
* Hint - vend_ax , also Cy4611B is useful here ( processCBW )
*
* This code is for Linux - I’m sure the same could be performed under windows
* gcc -o mba_powerup mba_powerup.c
*/
#include <fcntl.h>
#include <sys/ioctl.h>
#include <scsi/sg.h>
#include <stdio.h>
#include <string.h>
void mba_powerup (const char *device)
{
    int fd;
    sg_io_hdr_t IO_hdr;
    unsigned char magic[] = {0xea,0x00,0x00,0x00,0x00,0x00,0x01};
    unsigned char sbuf[32];
    unsigned char dxfp[32];

    fd = open(device, O_RDWR|O_NONBLOCK);
    if (fd < 0) {
        fprintf(stderr, "Error opening device \"%s\".\n", device);
        return;
    }
    else {
        memset(&IO_hdr, 0, sizeof(sg_io_hdr_t));
        IO_hdr.interface_id = 'S';
        IO_hdr.cmd_len = sizeof(magic);
        IO_hdr.mx_sb_len = sizeof(sbuf);
        IO_hdr.dxfer_direction = SG_DXFER_TO_DEV;
        IO_hdr.dxfer_len = sizeof(dxfp);
        IO_hdr.dxferp = dxfp;
        IO_hdr.cmdp = magic;
        IO_hdr.sbp = sbuf;
        IO_hdr.timeout = 1000;
        if ( ioctl(fd, SG_IO, &IO_hdr)< 0) {
            fprintf(stderr, "Error powering MBA SuperDrive.\n");
            return;
        }
        close(fd);
    }
}

int main(int argc,char **argv)
{
    mba_powerup(argv[1]);
    return 0;
}
