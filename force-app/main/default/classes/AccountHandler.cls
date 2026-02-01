public class AccountHandler {
    
    public static void handleAfterUpdate(List<Account> accList, Map<Id, Account> accOldMap){
        Map<Id, Account> updatedAccounts = new Map<Id, Account>();
        for(Account acc : accList){
            if(acc.Phone != accOldMap.get(acc.Id).Phone){
                updatedAccounts.put(acc.Id, acc);
            }
        }
        List<Contact> conList = [select Id, Phone, AccountId from Contact where AccountId IN :updatedAccounts.keySet()];
        List<Contact> contactsToUpdate = new List<Contact>();
        for(Contact con : conList){
            con.Phone = updatedAccounts.get(con.AccountId).Phone; 
            contactsToUpdate.add(con);
        }
        if(!contactsToUpdate.isEmpty()){
            List<Database.SaveResult> sr = Database.update(contactsToUpdate, false);
            for(Database.SaveResult s : sr){
                if(!s.isSuccess()){
                    for(Database.Error e : s.getErrors()){
                        System.debug('Update failed: ' + e.getMessage());
                    }
                }
            }
        }
    }

}