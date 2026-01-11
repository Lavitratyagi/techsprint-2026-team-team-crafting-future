# 🚀 Envidex
> A data-driven platform to analyze national stability, humanitarian risk, and policy outcomes using real-world indices.

---

## 👥 Team Details

| Name | Role | Email |
|------|------|--------|
| Kumar Tejaswee | Backend, AI | tejas16824@gmail.com |
| Saumya Sinha | Team Lead | riotstriker@gmail.com |
| Lavitra Tyagi | Mobile App | lavitratyagi@gmail.com |
| Roshni Pal | UI/UX, Research| roshnipal1012@outlook.com |

---

## 🎯 Problem Statement

Governments, NGOs, and citizens lack access to centralized and interpretable policy impact data.  
Critical socio-economic indicators are scattered across platforms, making it difficult to assess how policies affect public well-being and stability.

- **Context:** Policy decisions are often made without unified indicators.  
- **Impact:** Leads to inefficient policies, misinformation, and delayed humanitarian response.

---

## 💡 Solution Overview

**Envidex** is a role-based analytical platform that:
- Collects real-world geopolitical, economic, and social data
- Converts raw metrics into standardized indices
- Normalizes indicators for cross-country and inter-state comparison
- Provides dashboards, simulations, and behavioral trend insights

### Supported User Groups
- 👤 Common Citizens  
- 🧑‍💼 Political Candidates  
- 🏛 NGOs / Researchers / International Bodies  

---

## 🔐 Authentication & User Roles

Users register using:
- Username
- Password
- Role selection

### Role-Based Verification
- **Political Candidates:** State, Party, Position, Government ID  
- **NGOs/Researchers:** NGO Name, Registration ID, Address  

Each role receives customized dashboards and tools.

---

## 📊 Data Pipeline Architecture

### Step 1: Raw Data Collection (Country & State Level)

| Category | Data Examples |
|--------|--------------|
| Economic Sanctions | UN sanctions, OFAC lists |
| Trade Restrictions | Tariff rates, embargo data |
| Energy Export Controls | Fuel export volumes, restrictions |
| Aid Flow | Foreign aid inflow/outflow |
| Healthcare Access | Doctors per capita, hospitals |
| Food Security | Hunger index, food availability |
| Refugee Risk | Refugee & IDP counts |
| Economic Stability | GDP growth, inflation, unemployment |
| Civilian Well-being | Poverty, education, life expectancy |

---

### Step 2: Data Sources

Data is collected from:
- World Bank Open Data  
- WHO Global Health Observatory  
- FAO & World Food Programme  
- UNHCR Refugee Statistics  
- IMF World Economic Outlook  
- WTO Trade Databases  
- IEA / EIA Energy Reports  

Formats:
- CSV / Excel Downloads  
- Public APIs  
- Scheduled Batch Updates  

---

### Step 3: Index Construction

Raw metrics are converted into composite indices:

| Index | Built From |
|--------|------------|
| Civilian Well-being Index | Poverty, education, life expectancy |
| Economic Stability Index | GDP growth, inflation, employment |
| Healthcare Access Index | Doctors, hospitals, health spending |
| Food Security Index | Hunger scores, food supply |
| Refugee Risk Index | Refugee + IDP flows |
| Sanctions Severity Index | Sanction counts & duration |
| Trade Restriction Index | Tariffs & embargo levels |
| Energy Export Control Index | Fuel export disruptions |
| Aid Flow Adjustment Index | Aid inflow/outflow variation |

Each index uses:
- Standardization (Z-score)
- Weighted or averaged metrics

---

### Step 4: Normalization

All indices are normalized to a **-1 to +1 scale** using:

**Normalized = 2 * (x - min(x)) / (max(x) - min(x)) - 1**

Meaning:
- **-1** → Critical condition  
- **0** → Neutral / stable  
- **+1** → Highly positive  

This allows fair comparison across regions.

---

## 📈 System Outputs

### ✅ Current National Status
- Overall stability score
- Sector-wise performance indicators

### ✅ State-Level Situation Mapping
- Regional comparison dashboards
- Interactive geographic maps

### ✅ Trend-Based Behavioral Indicators
- Policy impact patterns
- Social risk detection
- Governance stability signals

---

## 👤 Common People Module

**Features:**
- News feed with category filters:
  - Trending, Policies, Education, Healthcare, Finance
- Search by keyword
- Stats Page:
  - Country and state selection
  - World map visualization
- Policy Simulator:
  - Choose policy sector
  - Adjust parameters
  - View predicted outcomes

Goal: Improve civic awareness using real data instead of political narratives.

---

## 🧑‍💼 Political Candidate Module

Includes all citizen features plus:
- **Policy Market Behavior Tool**
  - State-level feasibility testing
  - Public response prediction
  - Risk analysis

Goal: Promote evidence-based and feasible policymaking.

---

## 🏛 NGO / Researcher Module

Features:
- Advanced analytics dashboards
- Humanitarian risk monitoring
- Aid impact evaluation
- Multi-country comparisons

Goal: Support crisis planning and development strategies.

---

## 🤖 AI Agents for Policy Support

**AI agents analyze:**
- State-level indices
- Party behavior history
- Past policy outcomes
- Inter-party relationships

**Used for:**
- Policy outcome forecasting
- Conflict risk detection
- Development prioritization

Each state is modeled independently for accuracy.

---

## 🛠 Tech Stack

| Layer | Technology |
|--------|------------|
| Frontend | React, Tailwind CSS |
| Backend | Node.js, Express |
| Data Processing | Python, Pandas, NumPy |
| ML Models | Scikit-learn |
| Database | PostgreSQL / MongoDB |
| Visualization | D3.js, Mapbox |
| APIs | Public global datasets |
| Deployment | Vercel / Render |

---

## 📊 MVP Features

- [x] Role-based authentication  
- [x] Index calculation pipeline  
- [x] Stats dashboard  
- [x] Policy simulator UI  
- [ ] Real-time data ingestion  
- [ ] ML-based behavior prediction  

---

## 🚀 Future Enhancements

- Live API-based data ingestion  
- NLP analysis of speeches and policies  
- Public sentiment modeling  
- District-level micro indicators  
- Explainable AI policy recommendations  

---

## 🔗 Links

- 🌐 Live Demo: Coming Soon  
- 📂 GitHub Repo: Add Link  
- 📹 Video Demo: Add Link  

---

## 🔑 Test Credentials
