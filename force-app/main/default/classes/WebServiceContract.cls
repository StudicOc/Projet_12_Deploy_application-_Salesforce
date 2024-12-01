@RestResource(urlMapping='/Contracts/*')
global with sharing class WebServiceContract {

    //---------------CREATE CONTRACT-----------------------//
            /*Création d’un contrat : 
        quand un contrat est créé dans le CRM AXG, 
        les informations sont envoyées vers Salesforce et l’Id de Salesforce est sauvegardé.
        */

    @HttpPost
    global static String createContract(String AccountId, Date StartDate, Integer ContractTerm, String Status) {
        

        Contract thisContract = new Contract();
        thisContract.AccountId = AccountId;
        thisContract.StartDate = StartDate;
        thisContract.ContractTerm = ContractTerm;
        thisContract.Status = Status;

        insert thisContract;

        return 'Nouveau contact crée, voici son ID: ' + thisContract.Id;

        
    }

      //------------UPDATE CONTRACT-------------//

    /*Modification d’un contrat : à chaque modification du contrat, 
    il faut mettre à jour le contrat dans Salesforce en se basant sur l’Id de Salesforce.*/
    @HttpPatch
    global static Id updateContractFields() {   
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contract thisContract = [SELECT Id FROM Contract WHERE Id = :contractId];

        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        for(String fieldName : params.keySet()) {
            System.debug('fieldName: ' + fieldName);
            System.debug('fieldValue: ' + params.get(fieldName));
            thisContract.put(fieldName, params.get(fieldName));
        }
        update thisContract;
        return thisContract.Id;
    }

    
}