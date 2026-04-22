
library(feather)
library(data.table)
data <- read.csv("//objectstore3.nrs.bcgov/S164/S63016/!Workgrp/Inventory/Compilation/ismc/forpublish/data_catalogue/data_catalogue20260415/publish_shiny_app/shiny_sample_site.csv", stringsAsFactors = FALSE)
dataDict <- read.csv("//objectstore3.nrs.bcgov/s164/S63016/!Workgrp/Inventory/Compilation/ismc/forpublish/data_catalogue/data_catalogue20260415/publish_shiny_app/data_dictionary.csv")
data$objectid <- seq.int(nrow(data))

data$YSM_MAIN_FM[data$YSM_MAIN_FM == ''] <- "N/A"
spatial <- subset(data, LAST_MSMT == 'Y' & BC_ALBERS_X > 0 & BC_ALBERS_Y > 0, select = c("objectid",
                                                                                         'SITE_IDENTIFIER',
                                                                                         "CLSTR_ID",
                                                                                         "VISIT_NUMBER",
                                                                                         "TSA_DESC",
                                                                                         "SAMPLE_ESTABLISHMENT_TYPE",
                                                                                         #"PROJECT_DESIGN",
                                                                                         "PSP_STATUS",
                                                                                         'BEC_ZONE',
                                                                                         "BECLABEL",
                                                                                         "YSM_MAIN_FM",
                                                                                         "MAT_MAIN_FM",
                                                                                         "BC_ALBERS_X",
                                                                                         "BC_ALBERS_Y",
                                                                                         "MEAS_YR",
                                                                                         "UTIL",
                                                                                         "SPB_CPCT_LS",
                                                                                         "BA_HA_LS",
                                                                                         "STEMS_HA_LS",
                                                                                         "VHA_WSV_LS",
                                                                                         "AGET_TLSO"))
spatial$objectid <- seq.int(nrow(spatial))
colnames(spatial) <- c("objectid",
                       'site_identifier',
                       "clstr_id",
                       "visit_number",
                       "tsa_desc",
                       "sampletype",
                       #"project_design",
                       "psp_status",
                       'bec_zone',
                       "beclabel",
                       "ysm_main_fm",
                       "mat_main_fm",
                       "bc_albers_x",
                       "bc_albers_y",
                       "meas_yr",
                       "util",
                       "spb_cpct_ls",
                       "ba_ha_ls",
                       "stems_ha_ls",
                       "vha_wsv_ls",
                       "aget_tlso")

colnames(spatial) <- c("objectid",
                       'samp_id',
                       "clstr_id",
                       "no_meas",
                       "tsa_desc",
                       "sampletype",
                       #"project_design",
                       "psp_status",
                       'bgc_zone',
                       "beclabel",
                       "ysm_main",
                       "mat_main",
                       "bcalb_x",
                       "bcalb_y",
                       "meas_dt",
                       "util",
                       "spb_cpct_ls",
                       "baha_liv",
                       "stemsha_liv",
                       "vha_wsv_ls",
                       "aget_tlso")

spatial$psp_act <- ''
spatial$psp_act[spatial$psp_status == 'A' & spatial$sampletype == 'PSP'] <- 'PA'
spatial$psp_act[spatial$psp_status == 'IA' & spatial$sampletype == 'PSP'] <- 'PI'
spatial$psp_act[spatial$sampletype == 'VRI'] <- 'VRI'
spatial$wsvha_liv <- as.integer(round(spatial$vha_wsv_ls)) 
spatial$wsvha_liv[is.na(spatial$vha_wsv_ls)] <- 0
spatial$aget_tlso[is.na(spatial$aget_tlso)] <- 0
spatial$tot_stand_age <- as.integer(round(spatial$aget_tlso))



write_feather(data,"app\\www\\export_ground_samples")
write_feather(spatial,"app\\www\\spatial3")
write_feather(dataDict,"app\\www\\dataDict")




