@RestResource(urlMapping='/Contacts/*')
global with sharing class WebServiceContact {

        //---------------CREATE CONTACT-----------------------//
    @HttpPost
    global static String createContact(String firstName, String lastName,String phone, String email) {
        
    List <Contact> existingContacts= [SELECT Id, Email FROM CONTACT WHERE Email=:email];
         
       if(existingContacts.isEmpty()) {
            Contact contact = new Contact();
            contact.FirstName = firstName;
            contact.LastName = lastName; 
            contact.Phone = phone;
            contact.Email = email;
            insert contact;
            return 'Nouveau contact crée, voici son ID: ' + contact.Id;
            

       }
       else {
            return 'Un contact existe déjà avec ce mail : ' + existingContacts[0].Email + ' possédant l\'ID suivant : ' + existingContacts[0].Id;
       }

    }
         //---------------UPDATE CONTACT-----------------------//
    @HttpPatch
    global static ID updateContactFields() {

     RestRequest request = RestContext.request;
     RestResponse response = RestContext.response;
    String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
    List <Contact> thisContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :contactId LIMIT 1];

     if (!thisContact.isEmpty()) {
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());

        for(String fieldName : params.keySet()) {
            thisContact[0].put(fieldName, params.get(fieldName));
         }
          update thisContact;
          return thisContact[0].Id;
    }
        else {
        response.statusCode = 404;
        response.responseBody = Blob.valueOf('{"error": "Le contact avec l\'Id : ' + contactId + ' n\'existe pas."}');
        return null; // Retourne null car la réponse est gérée par RestContext.response

        }
    }

    //---------------DELETE CONTACT-----------------------//
 
    @HttpDelete
    global static String deactivateContact(){
   
    RestRequest request = RestContext.request;
    String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

    List <Contact> thisContact = [SELECT Id, Active__c FROM Contact WHERE Id = :contactId];

    if (!thisContact.isEmpty()) {
        thisContact[0].Active__c = false;
        update thisContact[0];
        return thisContact[0].Id;
    }
    else {
        return 'Contact introuvable avec cette Id.';
    }

    }


   
       @HttpGet
        global static Contact getContactById() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
          request.requestURI.lastIndexOf('/')+1);
        Contact result =  [ SELECT Id, FirstName, LastName FROM Contact WHERE Id = :contactId];
        return result;
    }
}