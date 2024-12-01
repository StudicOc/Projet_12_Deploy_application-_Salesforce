@RestResource(urlMapping='/Contracts/*')
global with sharing class WebServiceContract {

    //---------------CREATE CONTRACT-----------------------//
    @HttpPost
    global static String createContract(String AccountId, String StartDate, Integer ContractTerm, String Status) {
        try {
            // Parse the date
            Date startDateParsed = Date.parse(StartDate);
            
            // Create a new Contract
            Contract thisContract = new Contract();
            thisContract.AccountId = AccountId;
            thisContract.StartDate = startDateParsed;
            thisContract.Status = 'Draft';
            thisContract.ContractTerm = ContractTerm;

            insert thisContract;
            return 'New contract created, here is the ID: ' + thisContract.Id;
        } catch (Exception e) {
            // Return an error message if parsing or any other operation fails
            return 'Error: ' + e.getMessage();
        }
    }
}
