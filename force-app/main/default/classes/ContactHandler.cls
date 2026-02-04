public without sharing class ContactHandler {
    
    //method to handle after insert scenerios
    public static void handleAfterInsert(List<Contact> conNewList){
        updateContactsCountOnAccount(conNewList);
    }
    
    //method to handle after update scenerios
    public static void handleAfterUpdate(List<Contact> conNewList, Map<Id, Contact> conOldMap){
        List<Contact> contactWhereAccountUpdated = new List<Contact>();
        for(Contact con : conNewList){
            if(con.AccountId != conOldMap.get(con.Id).AccountId){
                contactWhereAccountUpdated.add(con);
                contactWhereAccountUpdated.add(conOldMap.get(con.Id));
            }
        }
        if(!contactWhereAccountUpdated.isEmpty()){
            updateContactsCountOnAccount(contactWhereAccountUpdated);
        }

        Map<Id, String> accountIdToDescriptionMap = new Map<Id, String>();
        for(Contact con : conNewList){
            if(con.AccountId != null && con.Description != conOldMap.get(con.Id).Description){
                accountIdToDescriptionMap.put(con.AccountId, con.Description);
            }
        }
        List<Account> accountsToUpdate = [select Id, Name, Description from Account where Id IN : accountIdToDescriptionMap.keySet()];
        
        for(Account acc : accountsToUpdate){
            acc.Description = accountIdToDescriptionMap.get(acc.Id);
        }
        
        update accountsToUpdate; 
    
       
        }
    
    //method to handle after delete scenerios
    public static void handleAfterDelete(List<Contact> conOldList){
        
        updateContactsCountOnAccount(conOldList);
    }
    
    //method to handle after undelete scenerios
    public static void handleAfterUndelete(List<Contact> conNewList){
        
        updateContactsCountOnAccount(conNewList);
    }
    
    //roll up method for contacts count on account
    public static void updateContactsCountOnAccount(List<Contact> newConList){
        Set<Id> accountIdsForCountContacts = new Set<Id>();
        for(Contact con : newConList){
            if(con.AccountId != null){
                accountIdsForCountContacts.add(con.AccountId);
            }
        }
        List<Account> accountsToUpdate = [select Id, Count_of_Contacts__c, (select Id from Contacts) from Account where Id IN: accountIdsForCountContacts];
        for(Account acc: accountsToUpdate){
            acc.Count_of_Contacts__c = acc.Contacts.size();
        }
        Database.update(accountsToUpdate, false);
    }
    
}