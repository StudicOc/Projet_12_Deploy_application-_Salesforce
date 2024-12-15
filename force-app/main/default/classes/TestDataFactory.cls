public with sharing class TestDataFactory {

    public static Id createContact(String firstName, String lastName) {
        Contact con = new Contact(
            FirstName = firstName,
            LastName = lastName
        );
        insert con;
        return con.Id;
    }



    public static Id createContract(Id accountId, Integer contractTerm, Date startDate, String status) {
        Contract thisContract = new Contract(
            AccountId = accountId,
            ContractTerm = contractTerm,
            StartDate = startDate,
            Status = status
        );
        insert thisContract;
        return thisContract.Id;
    }

    public static  Id createAccount(String name, String phone) {  
        Account acc = new Account(
            Name = name,
            Phone = phone
        );
        insert acc;
        return acc.Id;
    }
}



