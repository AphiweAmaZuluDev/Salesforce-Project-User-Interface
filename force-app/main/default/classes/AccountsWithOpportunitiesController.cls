/**
 * Controller for the accountsWithOpportunities Visualforce page.
 * It queries Account records, selecting Name, Industry, and the custom
 * NumberOfOpportunities__c field to display in the table.
 */
public class AccountsWithOpportunitiesController {

    // Public getter method to expose the list of Accounts to Visualforce
    public List<Account> getAccounts() {
        try {
            // Query Account records. The NumberOfOpportunities__c field 
            // must be included in the SELECT clause.
            List<Account> accounts = [
                SELECT 
                    Id, 
                    Name, 
                    Industry, 
                    NumberOfOpportunities__c 
                FROM 
                    Account 
                ORDER BY 
                    NumberOfOpportunities__c DESC NULLS LAST // Prioritize accounts with opportunities
                LIMIT 
                    100 // Limit to 100 records for performance
            ];
            return accounts;
        } catch (Exception e) {
            // Log the error to the debug logs and return an empty list
            System.debug('Error querying accounts: ' + e.getMessage());
            return new List<Account>();
        }
    }
}