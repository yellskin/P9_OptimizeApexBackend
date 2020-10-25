/**
* @author:		 Frédéric VO
* @date:		 19/10/2020
* @description:	 Trigger on Order object calling apex class OrderHandler
*
*/
trigger OrderTrigger on Order (after insert, after update, before delete){
  switch on Trigger.operationType {
    when AFTER_INSERT {
      OrderHandler.calcSalesRevenuesAccount(Trigger.new,null);
    }
    when AFTER_UPDATE {
      OrderHandler.calcSalesRevenuesAccount(Trigger.new,Trigger.oldMap);
    }
    when BEFORE_DELETE {
      OrderHandler.calcSalesRevenuesAccount(Trigger.old,null);
    }
  }
}