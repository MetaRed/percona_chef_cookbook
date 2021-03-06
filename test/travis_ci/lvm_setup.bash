#!/bin/bash
##########################################
#  Setup Travis-CI docker host LVM mount #
#                                        #
#  1) Create disk images                 #
#  2) Mount disk images to loop devices  #
#  3) Create striped LVM raid set        #
#  4) Use xfs file system                #
#                                        #
#  by: Richard Lopez                     #
##########################################
#set -xv

# declare disk variables
STRIPE_NUM='5'
EXT_NUM='256'
IMG_DIR='/opt'
VG_NAME='vg_db_data'
LV_NAME='lv_db_data'
MNT_DIR='percona_data'
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)

echo "Creating Disk Images...1 of 4"
seq ${STRIPE_NUM} |sudo xargs -I{} -P${CPU_NUM} dd if=/dev/zero of=${IMG_DIR}/lvm{}.img bs=2000 count=1M

echo "Loop Mount Disk Images...2 of 4"
seq ${STRIPE_NUM} |sudo xargs -I{} -P${CPU_NUM} losetup /dev/loop{} ${IMG_DIR}/lvm{}.img

echo "LVM Setup...3 of 4"
sudo pvcreate --metadatatype 2 --dataalignment ${EXT_NUM}k /dev/loop[1-5]
sudo vgcreate vg_db_data --physicalextentsize ${EXT_NUM}k /dev/loop[1-5]
sudo lvcreate --extents 100%FREE --stripes ${STRIPE_NUM} --stripesize ${EXT_NUM} --name ${LV_NAME} ${VG_NAME}

echo "File System Setup...4 of 4"
sudo mkfs.xfs -f -b size=4k -d su=${EXT_NUM}k,sw=${STRIPE_NUM} /dev/${VG_NAME}/${LV_NAME}
sudo mkdir /${MNT_DIR}
sudo mount -t xfs /dev/${VG_NAME}/${LV_NAME} /${MNT_DIR}

exit 0
