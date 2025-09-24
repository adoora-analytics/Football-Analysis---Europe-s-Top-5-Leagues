# ⚽ 2024/25 Football Stats Review — Europe’s Top 5 Leagues

A data-driven review of the 2024/25 season across Europe’s Top 5 leagues — exploring player stats, team performance, and tactical trends using SQL, Power Query &amp; Power BI.

---

## 📖 Project Overview

This project provides an analytical review of the 2024/25 football season across Europe’s Top 5 leagues — Premier League, La Liga, Bundesliga, Serie A, and Ligue 1.
The aim is to evaluate player and team performance using advanced statistics, data modelling, and interactive Power BI dashboards.

Read full breakdown here 👉  [Medium Article](https://obajimiaduraa.medium.com/summary-ab7e5dffdfb9)

---

## 🔧 Tools & Technologies

- MySQL → Data cleaning, joins, and exploratory queries

- Power Query → Data transformation, unpivoting, and preprocessing

- Power BI → Data modelling, dashboard design and visualization



---

## 📊 Dataset

Source: Kaggle (FBref-based stats)

Size: ~2,000 rows, 250+ statistical fields

Structure:

Fact Table → Player Info (including position & age bins)

Dimension Tables → Attacking, Defensive, Passing, Possession, Goalkeeping




---

## 📌 Key Insights

- League-wide metrics on possession, passing accuracy, and defensive solidity

- Player radar charts for role-specific comparisons (attackers, defenders, goalkeepers)

- Nationality contributions showing how countries influence tactical identity

- Season-over-season view of balance across Europe’s top leagues



---

## 📂 Repository Structure

```bash
Football-Analytics-2024-25/
│
├── images/                       # Dashboard screenshots & visuals
│   └── football_szn_review-4.png
│
├── FootballSznAnalysis.pbix      # Power BI dashboard file
├── players_data-2024_2025.csv    # Player statistics dataset (Top 5 Leagues)
├── players_dataquery.sql         # SQL script for initial data queries
├── per 90 stats revised.sql      # SQL script for per 90 mins analysis
│
├── README.md                     # Project documentation
├── LICENSE                       # License information

---

## 🔗 Medium Article & Dashboard 

Read the full write-up here 👉 [Medium Article](https://obajimiaduraa.medium.com/summary-ab7e5dffdfb9)

Explore the interactive dashboard 👉 [Explore Dashboard](https://app.powerbi.com/view?r=eyJrIjoiMDZmNTVmY2EtZWUwMC00N2U4LWI1OTAtM2EzN2VjZjMyNDkxIiwidCI6ImE1ODNjYzNlLTRmNDgtNDM2Ni1hMTY1LWI5Mzk5YzM0ODY0MSJ9&pageName=6274d1e560532d8b5b02) 

---

## 🚀 How to Use

1. Clone the repository


2. Open the .pbix file in Power BI


3. Connect to the provided dataset or refresh queries to load updated stats



