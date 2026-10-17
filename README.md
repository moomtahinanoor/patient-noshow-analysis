# Patient No-Show Analysis: Do SMS Reminders Reduce Missed Appointments?

Missed appointments waste clinic capacity and delay patient care. This project asks whether SMS reminders reduce no-shows, using 110,000+ real appointment records, and shows why a naive A/B comparison gave the wrong answer.

**Tools:** SQL (SQLite) · R · SAS · Python · Claude API (AI agent)

## Key Findings

- **The naive comparison was misleading.** Patients who received a text missed *more* appointments (27.6% vs. 16.7%).
- **Booking lead time was a confounder.** Texts were only sent for appointments booked 3+ days ahead. Texted appointments averaged a 19-day wait vs. 6 days, and same-day appointments (4.6% no-show rate) were never texted.
- **Comparing similar appointments reversed the result.** Within every lead-time group where texts were sent, texted patients had 2.8–7.3 percentage points lower no-show rates (Simpson's paradox).
- **Logistic regression confirmed it.** Among 60,021 appointments booked 3+ days ahead, controlling for lead time, age, sex, welfare enrollment, hypertension, diabetes, and alcoholism, SMS reminders were associated with **23% lower odds of a no-show (OR 0.77, 95% CI 0.74–0.80)**.
- **Results replicated exactly** in R and SAS.

| Lead time | No text | Text | Difference |
|---|---|---|---|
| Same day | 4.6% | not texted | – |
| 1–2 days | 22.7% | not texted | – |
| 3–7 days | 26.6% | 23.8% | −2.8 pts |
| 8–14 days | 33.8% | 28.1% | −5.7 pts |
| 15–30 days | 36.9% | 29.8% | −7.1 pts |
| 31+ days | 37.5% | 30.2% | −7.3 pts |

## Data

[Medical Appointment No Shows](https://www.kaggle.com/datasets/joniarroba/noshowappointments) (Kaggle): 110,527 appointments from public clinics in Brazil, 2016. The dataset is not included in this repo; download it from Kaggle to run the code.

## Methods

1. **SQL (SQLite in Python):** data quality checks, removal of 6 invalid records (negative age, appointments dated before booking), feature creation (`no_show`, `lead_days`), and stratified comparisons by lead time.
2. **R:** rebuilt the clean dataset (110,521 rows, matching SQL), two-proportion test, and logistic regression with odds ratios and 95% confidence intervals.
3. **SAS:** DATA step cleaning, PROC FREQ chi-square test, and PROC LOGISTIC, reproducing the R results to three decimal places.
4. **AI agent (Python + Claude API):** answers plain-English questions about the data by writing and running SQL.

## AI Agent

The agent uses the Claude API with a single tool, `run_sql`, which executes queries against the cleaned database. Claude decides when to query, reviews the results, and explains them in plain language.

- **Guardrails:** read-only access (SELECT queries only) and a step limit to prevent runaway loops.
- **Analytical rules:** reports rates with group sizes, flags that the data is observational, and accounts for the lead-time confounder when discussing SMS effects.
- **Validation:** agent answers were checked against manually written SQL. Testing showed it occasionally relied on outside assumptions, so its instructions were tightened to calculate every number from the data.

Example: *"For patients over 60, what is the no-show rate for those who got a text vs. those who didn't?"*

## Limitations

- **Observational data:** SMS reminders were not randomly assigned, so results show association, not proven causation.
- **Repeat patients:** 110,521 appointments come from 62,299 patients, so observations are not fully independent and confidence intervals may be slightly too narrow.
- **Generalizability:** data comes from Brazilian public clinics in 2016 and may not reflect US clinics today.
- **Prediction:** the model's c-statistic (0.584) is modest. It estimates the SMS effect well but is not a strong predictor of individual no-shows.

## Repository Contents

| File | Description |
|---|---|
| `patient_noshow_analysis.ipynb` | SQL analysis and AI agent (Python) |
| `patient_noshow_R.ipynb` | Statistical testing and logistic regression (R) |
| `patient_noshow.sas` | SAS replication |

## Author

**Moomtahina Noor**, B.S. Public Health, Minor in Data & Decision Science, Virginia Tech (2026)
[LinkedIn](https://www.linkedin.com/in/moomtahinanoor)
