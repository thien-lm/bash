main() {
#dpkg -l | grep linux-image
  apt-mark hold linux-image-5.15.0-88-generic
  apt-mark hold linux-image-5.15.0-107-generic

  KERNELVER=5.15.0-88-generic
  MID=$(awk '/Advanced options for Ubuntu/{print $(NF-1)}' /boot/grub/grub.cfg | cut -d\' -f2)
  KID=$(awk "/with Linux $KERNELVER/"'{print $(NF-1)}' /boot/grub/grub.cfg | cut -d\' -f2 | head -n1)

# echo "GRUB_DEFAULT='${MID}>${KID}'" >> /etc/default/grub
# or prefer put it in a seprate file
  cat > /etc/default/grub.d/95-savedef.cfg <<EOF
  GRUB_DEFAULT=saved
  GRUB_SAVEDEFAULT=true
  EOF
  grub-editenv /boot/grub/grubenv set saved_entry="${MID}>${KID}"
  update-grub
}  

main "$@"
sleep infinity