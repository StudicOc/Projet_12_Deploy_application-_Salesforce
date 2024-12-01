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
    String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
    Contact thisContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :contactId LIMIT 1];

     if (thisContact != null) {
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());

        for(String fieldName : params.keySet()) {
            thisContact.put(fieldName, params.get(fieldName));
         }
          update thisContact;
          return thisContact.Id;
    }
        else {
             return 'Le contact avec l\'Id' + contactId + ' n\'existe pas.';
        }
    }

    //---------------DELETE CONTACT-----------------------//
 
    @HttpDelete
    global static String deactivateContact(){
   
    RestRequest request = RestContext.request;
    String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
    Contact thisContact = [SELECT Id, Active__c FROM Contact WHERE Id = :contactId];

    if (thisContact != null) {
        thisContact.Active__c = false;
        update thisContact;
        return 'Le contact : ' + thisContact.Id + ' n\'est plus actif.';
    }
    else {
        return 'Contact introuvable avec cette Id.';
    }

    }




    //------------ ACTIONS SUPPLEMENTAIRE-------------// 
    @HttpGet
    global static List<Contact> getAll() {   
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<Contact> result = [SELECT Id, Name FROM Contact];
        return result;
    }

  
    /*responseBody.put('error', message);
            response.statusCode = 404;*/
}
