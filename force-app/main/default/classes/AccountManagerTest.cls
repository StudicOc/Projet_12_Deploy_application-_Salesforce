
@isTest
private class AccountManagerTest {



@IsTest
public static void createAccount() {
        // Mock the REST Request
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Accounts/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');

        // Corrected JSON payload
        request.requestBody = Blob.valueOf(
            '{' +
            '"Name": "Test Account",' +
            '"Phone": "123-456-7890"' +
            '}'
        );

        RestContext.request = request;

        // Mock the REST Response
        RestResponse response = new RestResponse();
        RestContext.response = response;

        Test.startTest();
        String result = WebServiceAccount.createAccount('Test Account', '123-456-7890');
        Test.stopTest();

        // Validate the Account creation
        Account thisAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
        System.assertEquals('Test Account', thisAccount.Name, 'The account should have been inserted with the specified account name.');

        // Validate the mocked response
        response.responseBody = Blob.valueOf(result); // Set response body for validation
        System.assert(response != null, 'Response should not be null.');
        System.assert(response.responseBody.toString().contains(thisAccount.Id), 'The response should contain the account ID.');
    }



    @isTest
     public static void testUpdateAccountSuccess() {


        Id accountId = TestDataFactory.createAccount('Danone', '000000000000');
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Acounts/' + accountId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Name": "Danao"}');
        RestContext.request = request;

        Test.startTest();
        WebServiceAccount.updateAccountFields();
        Test.stopTest();

        Account updatedAccount = [SELECT Id, Name FROM Account WHERE Id = :accountId ];
        System.assertNotEquals(null, updatedAccount, 'Le contact devrait exister dans la base de données.');
        System.assertEquals('Danao', updatedAccount.Name, 'Le prénom devrait être mis à jour à Danao.');
     }


 @isTest
public static void testUpdateAccountFields_NonExistingAccount() {
    // Simuler une requête HTTP PATCH pour un ID valide mais inexistant
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    RestContext.request = req;
    RestContext.response = res;

    req.requestURI = '/services/apexrest/Accounts/003000000000000AAA'; // ID valide mais inexistant
    req.httpMethod = 'PATCH';
    req.requestBody = Blob.valueOf('{"Name": "NonExistant"}');

    Test.startTest();
    WebServiceAccount.updateAccountFields(); // Appel de la méthode
    Test.stopTest();

    // Vérifier le code de statut de la réponse
    System.assertEquals(
        404,
        RestContext.response.statusCode,
        'Le code de statut devrait être 404 en cas de contact introuvable.'
    );

    // Vérifier le contenu du corps de la réponse
    String expectedResponse = '{"error": "Le contact avec l\'Id : 003000000000000AAA n\'existe pas."}';
    System.assertEquals(
        expectedResponse,
        RestContext.response.responseBody.toString(),
        'Le corps de la réponse retourné est incorrect.'
    );
}

   @IsTest
    public static void testGetAccount() {
        // Étape 1 : Préparer un compte pour le test
        Account testAccount = new Account(
            Name = 'Test Account',
            Phone = '123-456-7890'
        );
        insert testAccount;

        // Étape 2 : Configurer le contexte de requête REST
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Accounts/' + testAccount.Id;
        request.httpMethod = 'GET';
        RestContext.request = request;

        RestResponse response = new RestResponse();
        RestContext.response = response;

        // Étape 3 : Appeler la méthode et capturer le résultat
        Test.startTest();
        Account resultAccount = WebServiceAccount.getAccount();
        Test.stopTest();

        // Étape 4 : Vérifier le résultat
        System.assertNotEquals(null, resultAccount, 'Le compte ne doit pas être nul.');
        System.assertEquals(testAccount.Id, resultAccount.Id, 'L\'ID du compte doit correspondre.');
        System.assertEquals('Test Account', resultAccount.Name, 'Le nom du compte doit correspondre.');
        System.assertEquals('123-456-7890', resultAccount.Phone, 'Le téléphone du compte doit correspondre.');
    }

        
    }
