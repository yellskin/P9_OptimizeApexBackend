/**
* @author:		 Frédéric VO
* @date:		 19/10/2020
* @description:	 Batch use for updating account's Sales Revenues (Only Orders with Status = 'Activated')
*
*/
global class BatchUpdateSalesRevenues implements Database.Batchable<sObject>, Database.Stateful{
    global BatchUpdateSalesRevenues() {

    }

    public String query;

    global Database.QueryLocator start(Database.BatchableContext bc){
        this.query = 'SELECT Id,Chiffre_affaire__c,(SELECT Id,TotalAmount FROM Orders WHERE Status = \'Activated\') FROM Account';
        return Database.getQueryLocator(this.query);
    }

    global void execute(Database.BatchableContext bc, List<Account> scope){
        Decimal SalesRevenue = 0;
        List<Account> accountListToUpdate = new List<Account>();
        for(Account account : scope){
            List<Order> orderListWithAccountIds = new List<Order>();
            orderListWithAccountIds = account.Orders;
            if(orderListWithAccountIds.size() > 0){
                for(Order order : orderListWithAccountIds){
                    SalesRevenue += order.TotalAmount;
                }
                account.Chiffre_affaire__c = SalesRevenue;
            } else {
                account.Chiffre_affaire__c = 0;
            }
            accountListToUpdate.add(account);
        }
        if(accountListToUpdate.size()>0){
            update(accountListToUpdate);
        }
    }

    global void finish(Database.BatchableContext bc){
        System.debug('JOB IS DONE');
    }
}