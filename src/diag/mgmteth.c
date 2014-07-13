#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "diag.h"

/* TODO(bluecmd): Test IRQ - should only be to de-mask the interrupts. */

#define MODER               0x00
#define TX_BD_NUM           0x20
#define MIISTATUS           0x3C
#define MAC_ADDR0           0x40
#define MAC_ADDR1           0x44

#define MODER_RXEN          0
#define MODER_TXEN          1
#define MODER_BRO           3
#define MODER_PROMISC       5
#define MODER_LOOPBCK       7

#define TX_BD_CRC           11
#define TX_BD_IRQ           14
#define TX_BD_RDY           15

#define RX_BD_E             15
#define RX_BD_IRQ           14

#define MIISTATUS_LINKFAIL  0

#define RX                  0x0000
#define TX                  0x2000

/* set 50% of the BDs to xmit, and 50% to rcv. */
#define TX_BD_NUM_VALUE     0x40
#define TX_BD               0x400
#define RX_BD               (TX_BD + (TX_BD_NUM_VALUE * 8))

#define PKT_SIZE            128

#define TIMER_HZ            100000

static void mgmteth_failure(int reason);

static size_t ptr;
static int stage = 0;
static int error = 0;
static int device_found = 0;
static uint8_t sample_packet[PKT_SIZE];
static uint8_t rx_packet[PKT_SIZE];

void mgmteth_test(void) {
  volatile uint32_t *moder = VPTR(MGMT_ETH_BASE + MODER);
  volatile uint32_t *miistatus = VPTR(MGMT_ETH_BASE + MIISTATUS);
  volatile uint32_t *mac_addr0 = VPTR(MGMT_ETH_BASE + MAC_ADDR0);
  volatile uint32_t *mac_addr1 = VPTR(MGMT_ETH_BASE + MAC_ADDR1);
  volatile uint32_t *tx_bd_num = VPTR(MGMT_ETH_BASE + TX_BD_NUM);
  volatile uint32_t *tx_bd = VPTR(MGMT_ETH_BASE + TX_BD);
  volatile uint32_t *rx_bd = VPTR(MGMT_ETH_BASE + RX_BD);
  volatile uint8_t *dma_tx = VPTR8(MGMT_ETH_DMA + TX);
  volatile uint8_t *dma_rx = VPTR8(MGMT_ETH_DMA + RX);
  uint32_t data = 0;

  test_failure_func = mgmteth_failure;

  STAGE(0) {
    test_section("Management Ethernet");
  } END_STAGE

  STAGE(1) {
    device_found = 0;
    test_start("Detecting interface");
    if (*moder == 0x0000a000) {;
      test_finish(OK, "Found");
    } else {
      test_finish(WARN, "Could not verify (try resetting)");
    }
  } ON_ERROR {
    test_finish(ERROR, "Not found");
  } END_STAGE

  STAGE(2) {
    uint32_t ticks;
    int i;
    test_start("Copying packet to DMA area");
    for(i = 0; i < PKT_SIZE; ++i) {
      sample_packet[i] = (uint8_t)i;
    }
    memset(sample_packet, 0xff, 6);
    sample_packet[6] = 0x00;  sample_packet[7] = 0x0c;
    sample_packet[8] = 0xde;  sample_packet[9] = 0xad;
    sample_packet[10] = 0xbe; sample_packet[11] = 0xef;
    sample_packet[12] = 0;    sample_packet[13] = 0;
    sample_packet[14] = 0x81; sample_packet[15] = 0x00;
    or1k_timer_init(TIMER_HZ);
    or1k_timer_enable();
    ticks = or1k_timer_get_ticks();
    memcpy((uint8_t*)dma_tx, sample_packet, PKT_SIZE);
    ticks = or1k_timer_get_ticks() - ticks;
    or1k_timer_disable();
    test_finish(OK, "OK, took %lu us", ticks * 10);
  } ON_ERROR {
    test_finish(ERROR, "Failed");
  } END_STAGE

  STAGE(3) {
    uint32_t ticks;
    test_start("Verifying packet in DMA area");
    or1k_timer_init(TIMER_HZ);
    or1k_timer_enable();
    ticks = or1k_timer_get_ticks();
    memcpy(rx_packet, (uint8_t*)dma_tx, PKT_SIZE);
    ticks = or1k_timer_get_ticks() - ticks;
    or1k_timer_disable();
    if (!memcmp(rx_packet, sample_packet, PKT_SIZE)) {
      test_finish(OK, "OK, took %lu us", ticks * 10);
      device_found = 1;
    } else {
      test_finish(ERROR, "Mismatch");
    }
  } ON_ERROR {
    test_finish(ERROR, "Failed");
  } END_STAGE

  if (!device_found) {
    stage = 0;
    diag_next();
    return;
  }

  STAGE(4) {
    test_start("Setting up device");
    *tx_bd_num = TX_BD_NUM_VALUE;
    *mac_addr1 = 0x0000000c;
    *mac_addr0 = 0xdeadbeef;
    *(tx_bd+1) = (uint32_t)dma_tx;
    *(rx_bd+1) = (uint32_t)dma_rx;
    *tx_bd = (PKT_SIZE << 16) | (1 << TX_BD_RDY) | (1 << TX_BD_IRQ) |
      (1 << TX_BD_CRC);
    *rx_bd = (1 << RX_BD_E) | (1 << RX_BD_IRQ);
    *moder |= (1 << MODER_RXEN) | (1 << MODER_TXEN) | (1 << MODER_LOOPBCK) |
      (1 << MODER_PROMISC) | (1 << MODER_BRO);
    test_finish(OK, "OK");
  } ON_ERROR {
    test_finish(ERROR, "Failed");
  } END_STAGE

  STAGE(5) {
    /* TODO(bluecmd): Use IRQ here as well */
    uint32_t ticks;
    test_start("Waiting on packet");
    or1k_timer_init(TIMER_HZ);
    or1k_timer_enable();
    ticks = or1k_timer_get_ticks();
    while(*(uint32_t*)dma_rx == 0x0);
    test_finish(OK, "OK, took %lu us", ticks * 10);
  } ON_ERROR {
    test_finish(ERROR, "Failed");
  } END_STAGE

  STAGE(6) {
    uint32_t ticks;
    test_start("Copying packet from DMA area");
    memset(rx_packet, 0, PKT_SIZE);
    or1k_timer_init(TIMER_HZ);
    or1k_timer_enable();
    ticks = or1k_timer_get_ticks();
    memcpy(rx_packet, (uint8_t*)dma_rx, PKT_SIZE);
    ticks = or1k_timer_get_ticks() - ticks;
    or1k_timer_disable();
    test_finish(OK, "OK, took %lu us", ticks * 10);
  } ON_ERROR {
    test_finish(ERROR, "Failed");
  } END_STAGE

  STAGE(7) {
    test_start("Comparing packets");
    if (!memcmp(rx_packet, sample_packet, PKT_SIZE)) {
      test_finish(OK, "Match");
    } else {
      test_finish(ERROR, "Differ");
      test_info("Sample packet");
      memory_dump(sample_packet, PKT_SIZE);
      test_info("Received packet");
      memory_dump(rx_packet, PKT_SIZE);
    }
  } ON_ERROR {
    test_finish(ERROR, "Failed");
  } END_STAGE

  STAGE(8) {
    int old_status;
    test_start("Cable status");
    old_status = (*miistatus & (1 << MIISTATUS_LINKFAIL));
    MB;
    if ((*miistatus & (1 << MIISTATUS_LINKFAIL)) == 0) {
      if (old_status == 0) {
        test_finish(OK, "Present");
      } else {
        test_finish(OK, "Present, but was previously unplugged");
      }
    } else {
      test_finish(ERROR, "Not present");
    }
  } ON_ERROR {
    test_finish(ERROR, "Failed");
  } END_STAGE


  or1k_timer_disable();
  stage = 0;
  diag_next();
}

static void mgmteth_failure(int reason) {
  error = 1;
  memory_test();
}
