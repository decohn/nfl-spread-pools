# nfl-spread-pools
## Aim
Develop machine learning models to predict the final scoring margins of games in
the 2023, 2024, and 2025 NFL regular seasons.
## Synopsis
* In one of the NFL spread pools that I participate in, the spreads are fixed on
Tuesdays and it's possible to "key" three picks each week, making them each
worth two points instead of one

* I wanted to develop a method of making my weekly picks that takes advantage of
the difference between the "true" point spreads and these stale spreads and also
incorporates DVOA Adjusted for Variation Early (DAVE), which is the best
predictor of future NFL team performance that I've encountered

* Using R, I trained a number of machine learning models to predict the final
scoring margin of
[2023](https://decohn.github.io/nfl-spread-pools/2023/model-training.html),
[2024](https://decohn.github.io/nfl-spread-pools/2024/model-training.html), and
[2025](https://decohn.github.io/nfl-spread-pools/2025/model-training.html)
NFL games using only these two features

* I selected the models that performed best in testing, and will track their
performance over the course of the season in spreadsheets:
[2023](https://docs.google.com/spreadsheets/d/1dVnTsDZvxPkLAsYW6SPb1tOTNHe2bxtRAAwpPIAYwj0/edit?usp=sharing)
,[2024](https://docs.google.com/spreadsheets/d/1JBq1UFqZq2qJ4yNGzO1uhW1N025U4mpf9HskR_mAEJI/edit?usp=sharing),
and [2025](https://docs.google.com/spreadsheets/d/19EcIMy3SI9OcOJ6cSzHigufCkOG7_MDhou8Ge8xSZG8/edit?usp=sharing).

## Rationale
Ever since 2011, I've participated in two annual NFL pools in which entrants
must pick the result of every regular-season game against the point spread.
While I enjoy the contests themselves, I also enjoy winning, and so I've spent
a considerable amount of time over the past 12 years thinking about how to
optimize my weekly picks.

Normally, it's extremely difficult to pick NFL games against the point spread
with more than 50% accuracy. The break-even point for a gambler betting at -110
odds is approximately 52.4%. Over a sufficiently long period of time, any casual
gambler's win rate is going to be below that mark, and they will lose money.
True professionals might be able to exceed 52.4% over the long term, but they
have time, knowledge, experience, and resources that I do not.

This would suggest that time spent fretting over my picks might be time wasted.
Fortunately, one of the two pools I participate in has a pair of very helpful
quirks:

1. The point spreads for each week's games are set on the preceding Tuesday,
based on the current Vegas line, and are not updated under any circumstances.

2. Each week, entrants can designate three of their picks as "Key Picks", which
will count for two points in the standings instead of one.

The combined effect of these quirks is enormous. Between the Tuesday on which
point spreads are set and the Sunday on which most games are played, significant
news about player injuries, weather forecasts, and other pertinent factors can
surface. Oddsmakers generally wish to attract equal amounts of money on the two
sides of each game, and so they will adjust the point spreads accordingly.
Since the point spreads that are available just before games kick off reflect
all available information about the teams, while the Tuesday point spreads do
not, the final point spreads are, on average, closer to the actual scoring
margin.

Being able to make picks on a Sunday against the Tuesday point spreads
is thus an enormous advantage, akin to being able to buy shares of stock at the
price they traded at five days prior. This makes it possible to significantly
exceed an accuracy of 50% in this pool for games where the point spread has
moved over time in response to developing news.

There might only be a few games each week where the pool's point spread differs
non-trivially from the "true" final spread, but this is where the second quirk
comes in. In a typical week, there will be 16 games played, and perhaps 3 in
which the point spread has shifted. "Keying" all three of these games allows
these high-confidence picks to make up 6 of the 19 total points available in the
pool that week - just over 30%. Having the ability to obtain 30% of all
available points at a higher rate - say 55-60% instead of 50% - provides a
considerable edge over the course of the season.

Unfortunately, I'm far from the only person in this pool who takes advantage of
its stale Tuesday spreads. If I want to maximize my chance of winning, I need to
decide on a method for picking games in which the point spread doesn't move (and
for deciding which picks to "key" when there aren't exactly three good options).
I don't need to exceed 52.4% accuracy here; I just need to do a little bit
better, on average, than the other entrants in the pool.

I've historically used DVOA Adjusted for Variation Early
([DAVE](https://www.ftnfantasy.com/articles/FTN/104143/week-1-dvoa-dominant-dallas-cowboys)),
a metric developed by Aaron Schatz, for this purpose. I've found it to be the
most reliable publicly available predictor of a team's future performance, and I
encourage reading more about it
[here](https://www.ftnfantasy.com/articles/FTN/103241/dvoa-explainer) if you're
interested. In past years I've often used a simple linear model to estimate
scoring margins based on the difference between the home team's and the road
team's DAVE.

I've done quite well in my NFL spread pools historically, but I've been
struggling over the last three years, with my best finish in that time being
10th in a pool with 60-70 participants. In 2023, I'll try constructing
several more formal and complex models that will integrate both the final point
spread and the DAVE difference to predict final scoring margins. We'll find out
if they can put me back on the podium.

Using the new models, 2023 and 2024 turned out to be good, but not great years
(11th out of 79 pool participants and 21st out of 83 participants). I'll be
running back the same types of models for 2025, with the benefit of an extra
year of training data. Hopefully they have a stronger performance this time
around!

## Methodology
Briefly, I'll use data from the 2020, 2021, 2022, 2023, and 2024 NFL regular
seasons to develop machine learning models that predict a game's scoring margin
based on a) the final point spread, and b) the difference in DAVE between the
two teams. I'll try several types of models, namely random forest regressors,
linear regression models, and support vector regressors, and will select a
couple to use in the 2023, 2024, and 2025 seasons. Data from the 2023 regular
season is only being used to train the 2024 and 2025 models, of course.

For more detail on the training, tuning, and testing of these models, please see
[this](https://github.com/decohn/nfl-spread-pools/blob/main/2025/model-training.Rmd)
Rmd file, or view the knitted HTML file
[here](https://decohn.github.io/nfl-spread-pools/2025/model-training.html).

Each Thursday and Sunday morning during the 2023, 2024, and 2025 regular
seasons, I'll use the make_weekly_predictions.R
[script](https://github.com/decohn/nfl-spread-pools/blob/main/make_weekly_predictions.R)
to predict the final scoring margin of each game being played that day. These
predictions will be stored within
[2023/weekly-predictions](https://github.com/decohn/nfl-spread-pools/tree/main/2023/weekly-predictions),
[2024/weekly-predictions](https://github.com/decohn/nfl-spread-pools/tree/main/2024/weekly-predictions),
and [2025/weekly-predictions](https://github.com/decohn/nfl-spread-pools/tree/main/2025/weekly-predictions),
and will guide my picks.

## Results
The main spreadsheet that I use each week to make my picks is publicly available
[here](https://docs.google.com/spreadsheets/d/19EcIMy3SI9OcOJ6cSzHigufCkOG7_MDhou8Ge8xSZG8/edit?usp=sharing).
It contains a "Predictor" sheet and an "Analyses" sheet, with the latter
containing a summary of model performance.

### The "Predictor" sheet
Here's a breakdown of the important columns of the "Predictor" sheet for the
2025 season, insofar as the machine learning models are concerned:
* **GG Line**: the point spread that pool participants are picking against, from
the perspective of the road team (i.e. negative spreads indicate that the road
team is favoured)

* **Final Betting Line**: the Vegas point spread as of shortly before the pool's
pick deadline (kickoff for all games played on Thursday, Friday, or Saturday,
and 10:00 am Pacific Time on Sunday for all other games)

* **DAVE Difference**: the DAVE of the home team minus the DAVE of the road
team. Once DAVE is no longer available (after roughly Week 13), weighted DVOA is
used instead.

* **2025 Linear Model, 2025 SVM2, 2025 SVM3, 2023 Linear Model, 2023 SVM3**: the
predicted difference in points between the home and road teams, according to the
specified model. Negative numbers indicate that the road team is projected to
win. See [here](https://decohn.github.io/nfl-spread-pools/2025/model-training.html)
for details on how these models were developed and selected.

This sheet contains a number of other metrics that aren't relevant either to the
models' predictions or performance. They largely reflect alternative prediction
methods that I have used in the past, or am considering using in the future,
but am not currently using. I'm just interested in tracking their performance.

### The "Analyses" sheet
This sheet records the performance of different prediction methods over each
week of the 2025 NFL regular season. The rows whose labels include "LM" or "SVM"
represent the machine learning models discussed above. All other rows either
track basic data (e.g. the rate at which favourites are covering the spread) or
track the performance of alternative methods.

The rows labelled "GG Picks" and "Yahoo Picks" track my personal performance in
the two NFL spread pools, with the former pool being the one discussed
extensively above, with Tuesday point spreads and "key" picks. The rows labelled
"GG Median" and "Yahoo Median" track the performance of the median participant
each week in each pool.
