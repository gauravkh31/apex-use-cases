trigger ContactTrigger on Contact(After Insert, After Update, After Delete, After Undelete){
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            ContactHandler.handleAfterInsert(Trigger.NEW);
        }
        if(Trigger.isUpdate){
           ContactHandler.handleAfterUpdate(Trigger.NEW, Trigger.oldMap); 
        }
        if(Trigger.isDelete){
            ContactHandler.handleAfterDelete(Trigger.OLD);
        }
        if(Trigger.isUndelete){
            ContactHandler.handleAfterUndelete(Trigger.NEW);
        }
    }
}