library(tidyverse)
library(geniusr)
#install_github('mattroumaya/geniusr')
# - need to install forked version because there is currently a bug with get_lyrics() (12/16/21)
library(tidytext)

# add to std songs
std_songs <-
  get_artist_songs_df(54197)


# remove songs with the same lyrics (acoustic versions)
std_songs <-
  std_songs %>%
  mutate(song_name = trimws(str_remove(song_name, "[(]acoustic[)]"))) %>%
  group_by(song_name) %>%
  slice(1)


# map song_id to get all lyrics
std_lyrics_id <-
  map(std_songs$song_id, ~get_lyrics_id(.))


# all together
all <- bind_rows(std_lyrics_id)

# save files
saveRDS(all, "Saves the Day Lyrics.rds", compress = T)
openxlsx::write.xlsx(all, "Saves the Day Lyrics.xlsx")
write.csv(all, "Saves the Day Lyrics.csv", row.names = F)