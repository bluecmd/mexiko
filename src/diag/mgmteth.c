#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "diag.h"

/* TODO(bluecmd): Test IRQ - should only be to de-mask the interrupts. */

#define MODER               0x00
#define TX_BD_NUM           0x20
#define MIISTATUS           0x3C

#define MODER_RXEN          0
#define MODER_TXEN          1
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
    *moder;
    test_finish(OK, "Found");
  } ON_ERROR {
    test_finish(ERROR, "Not found");
  } END_STAGE

  STAGE(2) {
    uint32_t ticks;
    test_start("Copying packet to DMA area");
    memset(sample_packet, 0x55, PKT_SIZE);
    or1k_timer_init(TIMER_HZ);
    or1k_timer_enable();
    ticks = or1k_timer_get_ticks();
    memcpy((uint8_t*)dma_tx, sample_packet, PKT_SIZE);
    ticks = or1k_timer_get_ticks() - ticks;
    or1k_timer_disable();
    test_finish(OK, "OK, took %lu us", ticks * 10);
    device_found = 1;
  } ON_ERROR {
    test_finish(ERROR, "Failed");
  } END_STAGE

  if (!device_found) {
    stage = 0;
    diag_next();
    return;
  }

  STAGE(3) {
    test_start("Setting up device");
    *tx_bd_num = TX_BD_NUM_VALUE;
    *(tx_bd+1) = (uint32_t)dma_tx;
    *(rx_bd+1) = (uint32_t)dma_rx;
    *tx_bd = (PKT_SIZE << 16) | (1 << TX_BD_RDY) | (1 << TX_BD_IRQ) |
      (1 << TX_BD_CRC);
    *rx_bd = (1 << RX_BD_E) | (1 << RX_BD_IRQ);
    *moder |= (1 << MODER_RXEN) | (1 << MODER_TXEN) | (1 << MODER_LOOPBCK) |
      (1 << MODER_PROMISC);
    test_finish(OK, "OK");
  } ON_ERROR {
    test_finish(ERROR, "Failed");
  } END_STAGE

  STAGE(4) {
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

  STAGE(5) {
    uint32_t ticks;
    test_start("Copying packet from DMA area");
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

  STAGE(6) {
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

  STAGE(7) {
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
