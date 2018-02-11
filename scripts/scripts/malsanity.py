import sys
import enum
from bs4 import BeautifulSoup

class Status(enum.Enum):
    watching = 1
    completed = 2
    hold = 3
    dropped = 4
    plan_to_watch = 6

maldataxml = sys.stdin.read()

maldata = BeautifulSoup(maldataxml, "xml")

debug_mode = True

ignore = set([
    1303,
])

for anime in maldata.myanimelist.find_all("anime"):

    title = anime.series_title.contents[0]
    status = Status(int(anime.my_status.contents[0]))
    has_start_date = anime.my_start_date.contents[0] != "0000-00-00"
    has_finish_date = anime.my_finish_date.contents[0] != "0000-00-00"
    score = int(anime.my_score.contents[0])
    watched_episodes = int(anime.my_watched_episodes.contents[0])
    series_episodes = int(anime.series_episodes.contents[0])
    animedb_id = int(anime.series_animedb_id.contents[0])

    if animedb_id in ignore:
        continue

    # Constraint 1:
    # Any anime in either currently watching or completed MUST have a start date

    if status in (Status.watching, Status.completed):
        if not has_start_date:
            print(f"{title} doesn't have a start date")

    # Constraint 2:
    # Any anime in completed MUST have a finish date
    if status == Status.completed:
        if not has_finish_date:
            print(f"{title} doesn't have a finish date")

    # Constraint 3:
    # Any anime in completed MUST have a score
    if status == Status.completed:
        if not score:
            print(f"{title} doesn't have a score")

    # Constraint 4:
    # Any anime in completed MUST have watched all the episodes
    if status == Status.completed:
        if watched_episodes != series_episodes:
            print(f"{title} hasn't watched all the episodes")

    # Constraint 5: 
    # Any anime in currently watching must have watched at least one episode (But not all of them)
    if status == Status.watching:
        if watched_episodes == series_episodes:
            print(f"{title} has watched all of the episodes, move to completed")
        if watched_episodes == 0:
            print(f"{title} has watched none of the episodes, move to PTW")

    # Constraint 6:
    # Any anime in PTW must not have any episodes watched.
    if status == Status.plan_to_watch:
        if watched_episodes != 0:
            print(f"{title} has watched some episodes, move to watching or completed")
