This dataset contains the complete voting history for each member of parliament on the various Brexit agreements. It is a collection of the binding ('meaningful') and non-binding ('indicative') votes in the House of Commons relating to the withdrawal of the United Kingdom from the European Union.

## Data

There is a single dataset with all voting histories:

```
data/brexit_parliament.csv
```

The dataset covers the Brexit agreements listed below. The data is primarily sourced from [data.parliament.uk](http://www.data.parliament.uk). While the share of a MP's constituency that voted _Leave_ in the 2016 Brexit referendum is sourced from the [House of Commons library](https://commonslibrary.parliament.uk/parliament-and-elections/elections-elections/brexit-votes-by-constituency/).

| Type                 | Date       | Title                                                                                |
|:---------------------|:-----------|:-------------------------------------------------------------------------------------|
| __Meaningful votes__ | 2019-03-29 | United Kingdom's withdrawal from the European Union                                  |
|                      | 2019-03-12 | Section 13(1)(b) of the European Union (Withdrawal) Act main motion                  |
|                      | 2019-01-15 | European Union (Withdrawal) Act main Motion (Prime Minister)                         |
| __Indicitive votes__ | 2019-04-01 | Nick Boles's motion D (Common Market 2.0)                                            |
|                      |            | Mr Clarke's motion C (Customs Union)                                                 |
|                      |            | Peter Kyle's motion E (Confirmatory public vote)                                     |
|                      |            | Joanna Cherry's motion G (Parliamentary Supremacy)                                   |
|                      | 2019-03-27 | Mr Baron's motion B (No deal)                                                        |
|                      |            | Nick Boles's motion D (Common market 2.0)                                            |
|                      |            | George Eustice's motion H (EFTA and EEA)                                             |
|                      |            | Mr Clarke's motion J (Customs union)                                                 |
|                      |            | Jeremy Corbyn's motion K (Labour's alternative plan)                                 |
|                      |            | Joanna Cherry's motion L (Revocation to avoid no deal)                               |
|                      |            | Margaret Beckett's motion M (Confirmatory public vote)                               |
|                      |            | Mr Fysh's motion O (Contingent preferential arrangements)                            |
|                      | 2019-01-29 | EU (Withdrawal) Act Section 13 Amdt (a) - Corbyn                                     |
|                      |            | EU (Withdrawal) Act Section 13 Amdt (o) - Blackford                                  |
|                      |            | EU (Withdrawal) Act Section 13 Amdt (g) - Grieve                                     |
|                      |            | EU (Withdrawal) Act Section 13 Amdt (b) - Cooper                                     |
|                      |            | EU (Withdrawal) Act Section 13 Amdt (j) - Reeves                                     |
|                      |            | EU (Withdrawal) Act Section 13 Amdt (i) - Spelman                                    |
|                      |            | EU (Withdrawal) Act Section 13 Amdt (n) - Brady                                      |
| __Other votes__      | 2019-03-13 | Main motion, as amended by amendment (a), on UK's withdrawal from the European Union |

## Preparation

Data processing is recorded and automated in a R script:

```
scripts/process.R
```
