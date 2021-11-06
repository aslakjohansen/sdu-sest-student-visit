#include <stdio.h>
#include <string.h>
#include <FreeRTOS.h>
#include <task.h>
#include <bl_uart.h>
#include "bl_gpio.h"

#include <bl602_gpio.h>
#include <bl602_adc.h>

#include "system.h"

#define DELAY (100)
#define PIN (14)

#define ADC_CHANNEL (ADC_CHAN1)
#define ADC_PIN (4)


void TaskSample (void *pvParameters)
{
    ADC_CFG_Type cfg = {
        .v18Sel=ADC_V18_SEL_1P82V,                // ADC 1.8V select
        .v11Sel=ADC_V11_SEL_1P1V,                 // ADC 1.1V select
        .clkDiv=ADC_CLK_DIV_16,                   // Clock divider
        .gain1=ADC_PGA_GAIN_NONE,                 // PGA gain 1
        .gain2=ADC_PGA_GAIN_NONE,                 // PGA gain 2
        .chopMode=ADC_CHOP_MOD_AZ_PGA_ON,         // ADC chop mode select
        .biasSel=ADC_BIAS_SEL_MAIN_BANDGAP,       // ADC current form main or aon bandgap
        .vcm=ADC_PGA_VCM_1V,                      // ADC VCM value
/*        .vref=ADC_VREF_2V,                      // ADC voltage reference*/
        .vref=ADC_VREF_3P2V,                      // ADC voltage reference
        .inputMode=ADC_INPUT_SINGLE_END,          // ADC input signal type
/*        .resWidth=ADC_DATA_WIDTH_16_WITH_256_AVERAGE, // ADC resolution and oversample rate*/
        .resWidth=ADC_DATA_WIDTH_12, // ADC resolution and oversample rate
        .offsetCalibEn=0,                         // Offset calibration enable
        .offsetCalibVal=0,                        // Offset calibration value
    };
    ADC_FIFO_Cfg_Type fifo_cfg = {
        .fifoThreshold = ADC_FIFO_THRESHOLD_1, // ADC FIFO threshold
        .dmaEn = DISABLE,                      // ADC DMA enable
    };
    
    ADC_Reset();
    ADC_Disable();
    ADC_Enable();
    ADC_Init(&cfg);
    ADC_Channel_Config(ADC_CHANNEL, ADC_CHAN_GND, 0);
    ADC_FIFO_Cfg(&fifo_cfg);
    
    while (1) {
        ADC_Start();
        while (ADC_Get_FIFO_Count() == 0)
            ;
        uint32_t regval = ADC_Read_FIFO();
        
        // from ADC_Parse_Result
        float coe=1.0;
        unsigned int val = (unsigned int)(((regval&0xffff)>>4)/coe);
        float f = (val*5/4096.0 - 0.5)/0.01;
        float c = (f-32)*5/9;
        
        
        printf("{\"temperature\": %f}\n", c);
    }
}

void bfl_main(void)
{
    system_init();
    bl_uart_init(0, 16, 7, 255, 255, 9600);
    printf("booted\n");
    xTaskCreate(TaskSample, "Sample", 1024, NULL, 1, NULL);
    vTaskStartScheduler();
}

