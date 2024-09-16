# Customer Support Queue Analysis
**A B2B SaaS Customer Support System Evaluation**

## Introduction

We are a B2B SaaS company specializing in enterprise solutions. Our customer support system operates on a First-Come, First-Served (FCFS) queue model. The system is two-sided, managing a queue of customers and a parallel queue of support staff.

Recently, we have received complaints regarding prolonged wait times, especially from some of our larger customers. This has raised concerns about the efficiency and effectiveness of our support system.

## Objectives

### Project Goals

- Conduct an Exploratory Data Analysis (EDA) to gain a deeper understanding of the problem.
- Develop a real-time operational dashboard for ongoing monitoring of the support system.
- Propose and evaluate potential improvements, including identifying necessary data for implementation.
- Implement the most viable solution to enhance system performance.

### Key Business Questions

The following business questions will guide our analysis:

- What are the average and median wait times for customers?
- At what threshold does wait time become excessive? Specifically, how long are customers who lodge complaints typically waiting?
- What proportion of users are experiencing excessive wait times?
- How is the issue of excessive wait times distributed among customers from companies of different sizes?

## Technologies Used

To achieve the project goals, the following technologies were employed:

1. **SQL**: For initial data extraction and profiling.
2. **Python**: Including libraries such as Jupyter, Pandas, Matplotlib, Seaborn, Plotly, and Dash for data cleaning, preprocessing, analysis, and visualization.
3. **Tableau**: For creating interactive and user-friendly dashboards.

## Repo
```
.
├── LICENSE
├── README.md
├── REPORT.md
├── code
│   ├── data-extract.sql
│   └── data-profiling.sql
├── data
│   ├── clean-dataset-sq.csv
│   └── query_results-2024-08-28_43438.csv
├── images
│   ├── issue_categories_pie.png
│   ├── wait_time_by_company_size.png
│   ├── wait_time_histogram.png
│   └── wait_time_vs_company_size.png
└── notebooks
    └── support-queue.ipynb
```

## Methodology

The support queue data resides in the company's relational database management system (PostgreSQL). Initially, SQL was used to profile the data and gather preliminary statistics. Subsequently, aggregated data from multiple tables were extracted for comprehensive analysis.

The data underwent a cleaning and preprocessing phase before being analyzed using Python to address the key business questions. To support our findings and recommendations, dashboards were created using both Python and Tableau.

The final deliverable includes a detailed data analysis report with actionable recommendations for improving the support system's efficiency.

## Next Steps

**Proposed Actions**:

- **Extend Analysis Scope**: Incorporate additional parameters by integrating data from supplementary tables such as `support_staff`, `users`, and `ticket_status` to enhance the robustness of the analysis.
- **Assess Data Analysis Frequency**: Determine whether this analysis is a one-time, ad-hoc request or if it will be a recurring need.
- **For Recurring Needs**:
    - **Develop a Data Engineering Pipeline**: Establish a comprehensive ETL/ELT pipeline with a workflow orchestrator for automated data extraction, transformation, and loading, along with advanced data modeling.
    - **Predictive Modeling**: Design and train predictive models to anticipate support queue dynamics, enabling proactive management and optimization.
    - **Automation**: Automate the entire analysis and reporting process to ensure consistent, real-time insights with minimal manual intervention.


### **Update**:
A solution for below recommendation in [`REPORT.md`](REPORT.md) has been created now and is availabe at [`https://github.com/ranga4all1/support-queue-assistant-rag`](https://github.com/ranga4all1/support-queue-assistant-rag)

- **Develop Self-Service Options for Common Issues**: Introduce a knowledge base or chatbot to handle frequently asked questions and routine issues.