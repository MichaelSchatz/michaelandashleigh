library(readxl)
library(dplyr)
clip <- pipe("pbcopy", "w")                       

guests = read_xlsx("/Users/mschatz/Downloads/GuestList.xlsx")

guests_invite = guests %>% 
    filter(is.na(`Expendable?`)) %>% 
    select(People) %>% 
    mutate(ID = row_number()) 

guests_parsed = guests_invite %>% 
    mutate(Names = purrr::map(People, ~ .x %>% strsplit(" & ") %>% unlist() %>% trimws() %>%  data.frame(Name = .))
    ) %>% 
    tidyr::unnest(cols= Names) %>% 
    select(Name, ID)

clip <- pipe("pbcopy", "w")                       
write.table(guests_parsed, file = clip, sep="\t", row.names=FALSE)                               
close(clip)
clip <- pipe("pbcopy", "w")                       
write.table(data, file=clip)  

