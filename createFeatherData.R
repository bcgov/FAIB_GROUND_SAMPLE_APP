
library(feather)
library(data.table)
data <- read.csv("GROUND_SAMPLE_DATA//shiny_sample_site_2023May25.csv", stringsAsFactors = FALSE)
dataDict <- read.csv("GROUND_SAMPLE_DATA//data_dictionary.csv")
data$objectid <- seq.int(nrow(data))

data$ysm_main_fm[data$ysm_main_fm == ''] <- "N/A"
spatial <- subset(data, last_msmt == 'Y' & BC_ALBERS_X > 0 & BC_ALBERS_Y > 0, select = c("objectid",
                                                                                         'site_identifier',
                                                                                         "CLSTR_ID",
                                                                                         "visit_number",
                                                                                         "TSA_DESC",
                                                                                         "sampletype",
                                                                                         "project_design",
                                                                                         "psp_status",
                                                                                         'BEC_ZONE',
                                                                                         "beclabel",
                                                                                         "ysm_main_fm",
                                                                                         "mat_main_fm",
                                                                                         "BC_ALBERS_X",
                                                                                         "BC_ALBERS_Y",
                                                                                         "meas_yr",
                                                                                         "UTIL",
                                                                                         "SPB_CPCT_LS",
                                                                                         "BA_HA_LS",
                                                                                         "STEMS_HA_LS",
                                                                                         "VHA_WSV_LS",
                                                                                         "aget_tlso"))
spatial$objectid <- seq.int(nrow(spatial))
colnames(spatial) <- c("objectid",
                       'site_identifier',
                       "clstr_id",
                       "visit_number",
                       "tsa_desc",
                       "sampletype",
                       "project_design",
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
                       "project_design",
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
write_feather(data,"GROUND_SAMPLE_DEPLOY\\www\\export_ground_samples")
write_feather(spatial,"GROUND_SAMPLE_DEPLOY\\www\\spatial3")
write_feather(dataDict,"GROUND_SAMPLE_DEPLOY\\www\\dataDict")




