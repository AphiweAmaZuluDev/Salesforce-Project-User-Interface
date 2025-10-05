# TechCo Services: Account and Opportunity Insight Dashboard 📊

A clean, single-view dashboard designed for **Account Managers** to gain immediate insights into Account metrics and the overall Opportunity pipeline.

---

## ✨ Key Features

* **Real-time Account Metrics:** Displays a list of Accounts with key details, including the dynamically calculated **Number of Opportunities**.
* **Secure Data Rollup:** Implements declarative and programmatic logic (Flows, Apex Trigger) to accurately maintain the Opportunity count on the parent Account record, addressing the lack of standard roll-up functionality for lookup relationships.
* **Pipeline Visualization:** Integrates a third-party Lightning Web Component (LWC) to present a secure, aggregated chart of Opportunities broken down by `StageName`.
* **Consolidated UI:** Both the Account table (Visualforce) and the Opportunity chart (LWC) are deployed together on a custom Lightning Home Page for an optimal user experience.

---

## 🛠️ Prerequisites

To deploy this project successfully, you must first install the required component from the AppExchange:

* **[Lightning Web Chart.js Component](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N3A00000FeB0fUAF):** This third-party LWC is used for the Opportunity Stage analysis chart. (The URL is an example and should be updated to the actual AppExchange link).

---

## 🏗️ Implementation Details

### 1. Account Opportunity Rollup Logic

To ensure 100% accurate, real-time data for the number of opportunities associated with an Account, a custom field and a robust automation stack were utilized.

#### Data Field

| Object | Field Name | Type | Purpose |
| :--- | :--- | :--- | :--- |
| `Account` | `Number_Of_Opportunities__c` | `Number` | Stores the total count of related Opportunity records. |

#### Data Synchronization Automation

The field is maintained using a blend of automation to cover all possible DML scenarios:

| Automation Type | Trigger Object | DML Action Handled | Purpose |
| :--- | :--- | :--- | :--- |
| Record-Triggered Flow 1 | `Opportunity` | `Create / Update` | Increments the Account count on creation, and handles re-parenting when the Account lookup changes. |
| Record-Triggered Flow 2 | `Opportunity` | `Delete` | Decrements the Account count when an Opportunity is deleted (moved to Recycle Bin). |
| Apex Trigger | `Opportunity` | `Undelete` | Handles the edge case of data restoration by incrementing the Account count when an Opportunity is undeleted. |
| Scheduled Flow | `Account` | `Data Backfill` | Activated as a one-time process to calculate and populate the `Number_Of_Opportunities__c` field for all existing Accounts in the organization. |

---

### 2. Visualforce Page Development

This page displays the Account rollup data with custom styling.

* **Page Name:** `accounts_with_opportunities`
* **Controller:** Standard Account Controller.
* **Functionality:** Displays a table of Account records, including: **Account Name**, **Industry**, and the calculated **Number of Opportunities**.
* **Styling:** Custom CSS was applied to ensure the Visualforce page has a clean, modern, and readable table design consistent with the overall "TechCo Services" application aesthetic.

---

### 3. Opportunity Stage Analysis Chart

The data visualization component provides a high-level view of the pipeline health.

* **Component Used:** Lightning Web Chart.js Component (Downloaded from AppExchange).
* **Data Source Query:** The component utilizes a secure SOQL query to fetch aggregated Opportunity data:

```sql
SELECT StageName label, COUNT(Id) value
FROM Opportunity WITH SECURITY_ENFORCED
GROUP BY StageName
LIMIT 10

## 🚀 Deployment and User Experience

The final step was consolidating the Visualforce component and the LWC into a single dashboard experience.

* **Lightning Application:** Created an application named **TechCo Services**.
* **Lightning Page:** A new Home Page named **TechCo Home** was configured to serve as the main dashboard.
* **Component Integration:**
    * The Visualforce Page (`accounts_with_opportunities`) was embedded into the **TechCo Home** page.
    * The **Lightning Web Chart.js Component** was embedded into the same page.
* **App Assignment:** The **TechCo Home** page was assigned as the default Home Page for users accessing the **TechCo Services** Lightning Application.