# load packages
pacman::p_load(plyr, dplyr, readr, tidyr, stringr, openxlsx)

# function to extract coefficients
StarCounter <- function(path){

    # get all file paths and define objects
    files <- list.files(path, full.names = T, recursive = T) %>% subset(.,grepl('.txt',.))
    df <- data.frame(stringsAsFactors = F)

    # load files and reshape
    for(i in 1:length(files)){
        temp <- read.delim(files[i], header = FALSE)
        index <- temp %>% subset(., V1 == 'Observations' | V1 == 'VARIABLES') %>% row.names(.) %>% as.numeric(.) %>% sort(.)
        colnames(temp) <- t(temp[index[1],])[,1] %>% as.character(.)
        temp <- temp[(index[1]+2):(index[2]-2), ] %>%
            subset(., VARIABLES != '') %>%
            gather(., dependent, coeff, -VARIABLES) %>%
            rename(independent = VARIABLES) %>%
            mutate(dependent = gsub("\\..*", "", dependent)) %>%
            mutate(filename = basename(files[i]))
        df <- rbind.fill(df, temp)
    }

    # summarize coefficients
    res <- df %>%
        subset(., coeff != '') %>%
        subset(., !dependent %in% c('lns1_1_1', 'Constant')) %>%
        subset(., !independent %in% c('lns1_1_1', 'Constant')) %>%
        mutate(sign = (substr(coeff, 1, 1) == '-') == FALSE) %>%
        mutate(sign = case_when(sign == T ~ 'share_pos', sign == F ~ 'share_neg')) %>%
        mutate(nstar = str_count(coeff, "\\*")) %>%
        mutate(sig = replace(nstar, nstar>0, 1)) %>%
        group_by(dependent, independent, sign) %>%
        summarize(share = mean(sig)) %>%
        spread(., sign, share) %>%
        mutate(share_pos = replace(share_pos, is.na(share_pos), 0)) %>%
        mutate(share_neg = replace(share_neg, is.na(share_neg), 0)) %>%
        arrange(dependent, independent, share_pos, share_neg)
    return(res)
}
