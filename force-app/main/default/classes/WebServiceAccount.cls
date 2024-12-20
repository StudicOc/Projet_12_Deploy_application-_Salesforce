@RestResource(urlMapping='/Accounts/*')
global with sharing class WebServiceAccount {

 @HttpPost
    global static String createAccount(String name, String phone) {
        RestRequest request = RestContext.request;

        
        Account account = new Account(
            Name = name,
            Phone = phone
        );
        insert account;

        
        return 'Nouveau account crée, voici son ID: ' + account.Id;
    }
 
    @HttpGet
    global static Account getAccount() {
        RestRequest request = RestContext.request;

        String accountId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
            Account result = [
                SELECT Name, Phone
                FROM Account
                WHERE Id = :accountId
            ];
            return result;
    }


           //---------------UPDATE Account-----------------------//
    @HttpPatch
    global static ID updateAccountFields() {

     RestRequest request = RestContext.request;
     RestResponse response = RestContext.response;
    String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
    List <Account> thisAccount = [SELECT Id, Name FROM Account WHERE Id = :accountId LIMIT 1];

     if (!thisAccount.isEmpty()) {
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());

        for(String fieldName : params.keySet()) {
            thisAccount[0].put(fieldName, params.get(fieldName));
         }
          update thisAccount ;
          return thisAccount[0].Id;
    }
        else {
        response.statusCode = 404;
        response.responseBody = Blob.valueOf('{"error": "Le contact avec l\'Id : ' + accountId + ' n\'existe pas."}');
        return null; // Retourne null car la réponse est gérée par RestContext.response

        }
    }






}