/**
* @author:		 Frédéric VO
* @date:		 19/10/2020
* @description:	 Test batch named BatchUpdateSalesRevenuesSchedule
*
*/
@isTest
private class BatchUpdateSalesRevenuesScheduleTEST {
    @isTest static void testAccountBatchSchedule(){
        Test.startTest();
        System.schedule('BatchUpdateSalesRevenuesSchedule', '0 0 3 * * ?', new BatchUpdateSalesRevenuesSchedule());
        Test.stopTest();
        }
}