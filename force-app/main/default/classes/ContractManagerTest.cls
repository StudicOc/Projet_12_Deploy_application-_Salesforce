@IsTest
private class ContractManagerTest {

@IsTest
public static void testCreateContractSuccess() {
    // Préparation des données
    Id accountId = TestDataFactory.createAccount('Test Account', '123-456-7890');

    // Appel de la méthode de création
    Test.startTest();
    String response = WebServiceContract.createContract(accountId, Date.today(), 12, 'Draft');
    Test.stopTest();

    // Vérification de la réponse
    System.assert(response.startsWith('Nouveau contact crée, voici son ID:'), 
                  'La réponse doit confirmer la création du contrat.');

    // Extraction de l'ID et vérification dans la base
    String contractId = response.split(': ')[1]; // Récupère l'ID dans la réponse
    System.assertNotEquals(null, [SELECT Id FROM Contract WHERE Id = :contractId], 
                           'Le contrat doit être créé et exister dans la base de données.');
}



    @IsTest
    static void testUpdateContractField() {
     
        Id accountId = TestDataFactory.createAccount('Test Account', '123-456-7890');
        Id contractId = TestDataFactory.createContract(accountId, 12, Date.today(), 'Draft');

 
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Contracts/' + contractId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"ContractTerm":3}');
        RestContext.request = request;

      
        Id updatedContractId = WebServiceContract.updateContractFields();

        Contract updatedContract = [SELECT Id, ContractTerm FROM Contract WHERE Id = :updatedContractId];
        System.assertNotEquals(null, updatedContract, 'Updated contract should not be null.');
        System.assertEquals(3, updatedContract.ContractTerm, 'Contract term should be updated to 3.');
    }



}
