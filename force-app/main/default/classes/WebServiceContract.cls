@RestResource(urlMapping='/Contracts/*')
global with sharing class WebServiceContract {

    //---------------CREATE CONTRACT-----------------------//
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

@HttpPatch
global static Id updateContractFields() {   
    RestRequest request = RestContext.request;
    String contractId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

    // Récupérer le contrat existant
    Contract thisContract = [SELECT Id, AccountId, StartDate, ContractTerm, Status FROM Contract WHERE Id = :contractId LIMIT 1];

    // Désérialiser le JSON en une Map
    Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.toString());

    for (String fieldName : params.keySet()) {
        Object fieldValue = params.get(fieldName);
        System.debug('fieldName: ' + fieldName);
        System.debug('fieldValue: ' + fieldValue);

        // Vérification et conversion pour le type Date
        if (fieldName == 'StartDate' && fieldValue != null) {
            thisContract.put(fieldName, Date.valueOf((String)fieldValue));
        } else {
            thisContract.put(fieldName, fieldValue);
        }
    }
    
    // Mettre à jour le contrat
    update thisContract;
    return thisContract.Id;
}

     
   
}


// Ajouter WEB SERVICE ACCOUNT -OK
// Formule pour alimenter automatiquement le champs externalId à partir de l'id ou email -  a finir 
// TERMINER LA CONFIGURATION HEROKU 
// COMMENCER LA DOC = POSTMAN API REST - exporter collection au format json 

//--20/12
// Corriger externalID
// Test de puis Heroku - montrer les resultats sur salesforce 
// PGAdmin- PostGres 
// DOC - deployement ( Salesforce + Heroky ( postgre + herokuConnect))