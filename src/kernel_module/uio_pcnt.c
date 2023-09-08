#include <linux/device.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/uio_driver.h>

#include <asm/io.h>  //Why?

#define VERSION "0.1"
#define AUTHOR "Matteo Vidali"
#define LICENSE "GPL v2"
#define DEVNAME "popcount-uio"

#define BASE_ADDR 0x40000000
#define SIZE      0x10000

static struct uio_info *info; // This is the vital dev info struct
static struct device *dev; // device structure

static void popcount_release(struct device *dev){
  printk(KERN_INFO "popcount Device Released\n");
}
// IRQ return handler - Nothing for now 
static irqreturn_t popcount_handler(int irq, struct uio_info *dev_info){
  // debug message
  printk(KERN_INFO "Popcount IRQ handler triggered ...\n");
  return IRQ_HANDLED;
}

// initializer
static int __init popcount_init(void){

  dev = kzalloc(sizeof(struct device), GFP_KERNEL);
  
	dev_set_name(dev,DEVNAME);
  dev->release = popcount_release;

// These lines are a bit annoying, but there are warnings when doing this;
// The device_register function expects to be used in conjunction with
// a device tree, but since we don't have one we just suppress the warnings.
#pragma GCC diagnostic push 
#pragma GCC diagnostic ignored "-Wunused-result"
  (void)device_register(dev);
#pragma GCC diagnostic pop

  info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);

  info->mem[0].size = SIZE;
  info->mem[0].memtype = UIO_MEM_PHYS;
  info->mem[0].addr = BASE_ADDR;
  info->mem[0].name = "popcount_reg";

  info->name = DEVNAME;
  info->version = VERSION;
  info->irq = UIO_IRQ_NONE;
  info->irq_flags = UMH_DISABLED;//IRQF_DISABLED;
  info->handler = popcount_handler;

  uint32_t check = uio_register_device(dev, info);

  if (check < 0){
    device_unregister(dev);
    kfree(dev);
    kfree(info);
    printk(KERN_ALERT "Failed to register popcount_uio dev\n");
    return check;
  }
  
  printk(KERN_INFO "Registered popcount UIO handler\n");
  return 0;
}

static void __exit popcount_exit(void){
  uio_unregister_device(info);
  device_unregister(dev);
  printk(KERN_INFO "Un-Registerd popcount UIO handler\n");
  kfree(info);
  kfree(dev);
}

module_init(popcount_init);
module_exit(popcount_exit);

MODULE_DESCRIPTION("this is the popcount uio device");
MODULE_AUTHOR(AUTHOR);
MODULE_LICENSE(LICENSE);
