@isTest
private class ContactManagerTest {

    @IsTest
    public static void testCreateContactSuccess() {
        // Étape 1 : Assurez-vous qu'il n'y a aucun contact avec l'email utilisé pour le test
        String email = 'testcreate@example.com';
        List<Contact> existingContacts = [SELECT Id FROM Contact WHERE Email = :email];
        System.assertEquals(0, existingContacts.size(), 'Aucun contact ne devrait exister avant le test.');

        // Étape 2 : Appeler la méthode pour créer un nouveau contact
        Test.startTest();
        String response = WebServiceContact.createContact('John', 'Doe', '1234567890', email);
        Test.stopTest();

        // Étape 3 : Vérifier que le contact a été créé
        Contact createdContact = [SELECT Id, FirstName, LastName, Email, Phone 
                                  FROM Contact 
                                  WHERE Email = :email];

        System.assertNotEquals(null, createdContact, 'Un nouveau contact devrait être créé.');
        System.assertEquals(email, createdContact.Email, 'L\'email devrait être celui utilisé.');
        System.assert(response.contains(createdContact.Id), 'La réponse devrait contenir l\'ID du contact.');
    }

    @IsTest
    public static void testCreateContactFails() {
        // Étape 1 : Préparation des données - insertion d'un contact existant
        String email = 'testcreate@example.com';
        Contact existingContact = new Contact(
            FirstName = 'Existing',
            LastName = 'Contact',
            Email = email
        );
        insert existingContact;

        // Vérifiez qu'un contact existe déjà avec cet email
        List<Contact> preExistingContacts = [SELECT Id, Email FROM Contact WHERE Email = :email];
        System.assertEquals(1, preExistingContacts.size(), 'Un seul contact doit exister avant le test.');

        // Étape 2 : Tenter de créer un contact avec le même email
        Test.startTest();
        String response = WebServiceContact.createContact('John', 'Doe', '1234567890', email);
        Test.stopTest();

        // Étape 3 : Vérification de l'échec
        System.assert(response.contains('Un contact existe déjà avec ce mail'),
                      'Le message d\'erreur doit indiquer qu\'un contact existe déjà avec cet email.');

        // Vérifiez qu'aucun nouveau contact n'a été créé
        List<Contact> contactsAfterAttempt = [SELECT Id FROM Contact WHERE Email = :email];
        System.assertEquals(1, contactsAfterAttempt.size(), 'Aucun contact supplémentaire ne doit être créé.');
    }

    @IsTest
    public static void testGetContactById() {
        Id recordId = TestDataFactory.createContact('Severine', 'Rogriguez');

        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Contacts/' + recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;

        Test.startTest();
        Contact thisContact = WebServiceContact.getContactById();
        Test.stopTest();

        System.assertNotEquals(null, thisContact, 'Le contact devrait être retourné.');
        System.assertEquals('Severine', thisContact.FirstName, 'Le prénom devrait correspondre.');
    }

    @IsTest
    public static void testUpdateContactFields() {
        Id contactId = TestDataFactory.createContact('Serine', 'Dupond');
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Contacts/' + contactId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"FirstName": "Sophie"}');
        RestContext.request = request;

        Test.startTest();
        WebServiceContact.updateContactFields();
        Test.stopTest();

        Contact updatedContact = [SELECT Id, FirstName FROM Contact WHERE Id = :contactId];
        System.assertNotEquals(null, updatedContact, 'Le contact devrait exister dans la base de données.');
        System.assertEquals('Sophie', updatedContact.FirstName, 'Le prénom devrait être mis à jour à Sophie.');
    }

    @IsTest
    public static void testUpdateContactFieldsFails() {
        Id contactId = TestDataFactory.createContact('Lucie', 'Duponds');

        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Contacts/xxx'; // Simuler un ID invalide
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"FirstName": "Sophie"}');
        RestContext.request = request;

        Test.startTest();
        String response = WebServiceContact.updateContactFields();
        Test.stopTest();

        System.assertNotEquals(null, response, 'La réponse ne devrait pas être nulle en cas d\'ID invalide.');
        System.assertEquals('The ID of the contact to update is missing.', response, 'Le message d\'erreur devrait être retourné.');
    }

    @IsTest
    public static void testDeactivateContact() {
        Id contactId = TestDataFactory.createContact('Lucie', 'Duponds');
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Contacts/' + contactId;
        request.httpMethod = 'DELETE';
        RestContext.request = request;

        Test.startTest();
        WebServiceContact.deactivateContact();
        Test.stopTest();

        Contact thisContact = [SELECT Id, Active__c FROM Contact WHERE Id = :contactId];
        System.assertNotEquals(null, thisContact, 'Le contact devrait exister dans la base de données.');
        System.assertEquals(false, thisContact.Active__c, 'Le champ Active__c devrait être mis à false.');
    }

    @IsTest
    public static void testDeactivateContactFails() {
        Id contactId = TestDataFactory.createContact('Lucie', 'Duponds');
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Contacts/xxx';
        request.httpMethod = 'DELETE';
        RestContext.request = request;

        Test.startTest();
        String response = WebServiceContact.deactivateContact();
        Test.stopTest();

        System.assertEquals('Contact introuvable avec cette Id.', response, 'Le message d\'erreur devrait indiquer que le contact est introuvable.');
    }
}
