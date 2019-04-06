library(tidyverse)
library(hansard)
library(mnis)
library(httr)
library(readxl)
'%nin%' = Negate('%in%')


# Setup -------------------------------------------------------------------

# Find ID for each vote/division in the house of commons. Using dates from Wikipedia to narrow down search. 
# https://en.wikipedia.org/wiki/Brexit_negotiations_in_2019
brexit_commons_voting_dates = c("2019-01-15", "2019-01-29", "2019-03-12", "2019-03-13", "2019-03-14", "2019-03-27", "2019-03-29", "2019-04-01")
tmp.common.votes = brexit_commons_voting_dates %>% 
  map(function(x) {commons_divisions(start_date = x, end_date = x)}) %>% 
  bind_rows() %>% 
  select(-date_datatype)
tmp.common.votes


# Vote IDs for "Meaningful votes", "Indicitive votes" and "Other types of votes", respectively.
brexit_commons_mv = c(1041567, 1086876, 1107737)
brexit_commons_iv = c(
    c(1050638, 1050639, 1050640, 1050641, 1050642, 1050644, 1050712), # 2019-01-29
    c(1105521, 1105524, 1105526, 1105527, 1105529, 1105530, 1105532, 1105533), # 2019-03-27
    c(1108905, 1108904, 1108906, 1108907) # 2019-04-01
  )
brexit_commons_ov = c(1087778)
vote_ids = c(brexit_commons_mv, brexit_commons_iv, brexit_commons_ov) %>% as.character()



# Load data ---------------------------------------------------------------

# Votes in house of commons
df.commons = vote_ids %>% map(commons_divisions) %>% bind_rows()


# Active members in house of commons
df.members = mnis_mps_on_date(
    date1 = head(sort(brexit_commons_voting_dates), n=1), 
    date2 = tail(sort(brexit_commons_voting_dates), n=1)
  )
# Note that Paul Flynn (member_id == 545) retired 2019-02-17. He has not voted since june 2018. 
# https://hansard.parliament.uk/search/MemberContributions?memberId=545&startDate=04%2F05%2F2014%2000%3A00%3A00&endDate=04%2F05%2F2019%2000%3A00%3A00&type=Divisions


# Brexit referendum results
# https://commonslibrary.parliament.uk/parliament-and-elections/elections-elections/brexit-votes-by-constituency/
tmp = tempfile(fileext = ".xlsx")
GET(url = "https://commonslibrary.parliament.uk/wp-content/uploads/2017/02/eureferendum_constitunecy.xlsx", write_disk( tmp) )
df.referendum = read_xlsx(tmp, sheet = 2, skip = 8, col_names = c("ONS_ID", "Constituency", "CH_Leave_estimate", "Known_result", "Known_leave", "Leave_figure_to_use")) %>% 
  mutate(
    Constituency = replace(Constituency, Constituency == "Weston-Super-Mare", "Weston-super-Mare"),
    Constituency = replace(Constituency, Constituency == "Ynys Mon", "Ynys Môn")
  ) # Manually rename constituencies so they match `df.memebers$member_from`




# Merge data --------------------------------------------------------------

# Merge members with referendum data, and votes in commons with descriptions
tmp.df.members = df.members %>% 
  rename(Constituency = member_from) %>% 
  select(member_id, display_as, Constituency, party_text) %>% 
  left_join(
    df.referendum %>% select(Constituency, Leave_figure_to_use)
  )
tmp.df.commons = df.commons %>% 
  select(-label_value, -number, -member_party, -member_printed_value) %>%
  rename(member_id = about) %>% 
  left_join(
    tmp.common.votes %>% mutate(
      vote_type = ifelse(about %in% brexit_commons_mv, "meaningful", 
        ifelse(about %in% brexit_commons_iv, "indicitive", 
          ifelse(about %in% brexit_commons_ov, "other", NA)
        )
      )
    ),
    by = c("vote_id" = "about")
  )

# Merge into one
# df = tmp.df.commons %>% group_by(vote_id) %>% full_join(tmp.df.members) %>% fill(vote_id, title, uin, date_value, vote_type)
# Note `full_join()` ignores `group_by()`. I therefore create list with each group, apply join to every element in list, and finally bind list together again.
tmp.list.1 = tmp.df.commons %>%
  group_by(vote_id) %>%
  do(data = (.)) %>% 
  pull(data)
tmp.list.2 = tmp.list.1 %>% map(
    function(x) {
      x %>% 
        full_join(tmp.df.members) %>%
        fill(vote_id, title, uin, date_value, vote_type)
    }
  )
df.complete = tmp.list.2 %>% bind_rows()



# Polish data -------------------------------------------------------------

# Renaming, reformating, etc.
df = df.complete %>%
  rename(
    vote = type,
    vote_title = title,
    vote_uin = uin,
    vote_date = date_value,
    member = display_as,
    member_constituency = Constituency,
    member_party = party_text,
    member_constituency_leave_vote = Leave_figure_to_use
  ) %>% mutate(
    vote = str_remove(vote, "_vote") %>% as.factor(),
    vote_date = vote_date %>% as.Date(tz = .sys.timezone)
  )



# Save data ---------------------------------------------------------------

write_csv(df, "../data/brexit_parliament.csv")
