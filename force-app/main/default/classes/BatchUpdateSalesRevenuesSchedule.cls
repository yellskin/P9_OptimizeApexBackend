/**
* @author:		 Frédéric VO
* @date:		 19/10/2020
* @description:	 Batch schedulable to invoke Apex classes to run at specific times
*
*/
global class BatchUpdateSalesRevenuesSchedule implements Schedulable{
    global void execute(SchedulableContext ctx){
        BatchUpdateSalesRevenues batch = new BatchUpdateSalesRevenues();
        Database.executeBatch(batch,200);
    }
}