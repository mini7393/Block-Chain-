pragma solidity ^0.4.18;

contract propertyDetails{
    //ensure all text is small
     struct propertyDetail{
         string PlotNum;
         string regname;
         string currentowner;
         string previousowner ;
         string ptype;
         string data;
         status txnstatus;
         bytes32 prop_hash;
       
     }
        // 12,"regname","currentowner","","land"
        //0x5fd9da10b5bccbd37490e86099f7842f39458783af9b24a01afcbf5f62a48fbb
        
//      string aadhar;
//      bytes16 SRO_Code;
//      bytes16 SurveyNum;
//      bytes16 buildArea;
//      bytes32 public _hash;
 
     enum status {clean,newproperty,ownerchanged,registered,propertytransferred}
     
     status statuses =status.clean;
     
    event InsertPropertyDetails1(string _PlotNum,string _currentowner,string _previousowner);
    event InsertPropertyDetails2(string _PlotNum,string _regname,string _ptype,string data);

    event Changeowner(string _previousowner,string _currentowner,status _txnstatus);
   event Registration(string _oldregno, string _regname, status _txnstatus);
    //event Mutation(string _previousowner,string _currentowner,status _txnstatus);
     
     
    mapping (bytes32 => propertyDetail) pDetails;
    address owner;
   //bytes32 public sdfasd;
   
//   modifier listofowner(){
//       if(){}
       
//       else
//       _;
//   }
    
    function insertPropertyDetails(string _PlotNum,string _regname,string _currentowner,string _previousowner,
            string _ptype,string _data) public returns (bytes32,status){
        bytes32 _hash = keccak256(_PlotNum,_ptype);
        if (pDetails[_hash].prop_hash==_hash) revert();
        pDetails[_hash].PlotNum=_PlotNum;
        pDetails[_hash].regname=_regname;
        pDetails[_hash].currentowner=_currentowner;
        pDetails[_hash].previousowner=_previousowner;
        pDetails[_hash].ptype=_ptype;
        pDetails[_hash].data=_data;
        statuses = status.newproperty;
        pDetails[_hash].txnstatus=status.newproperty;
        pDetails[_hash].prop_hash=_hash;//sha3(_PlotNum);
//        return(_hash,pDetails[_hash].txnstatus);

        InsertPropertyDetails1(_PlotNum,_currentowner,_previousowner);
        InsertPropertyDetails2(_PlotNum,_regname,_ptype,_data);

        return(_hash,statuses);
     } 
    
     function getPropertyDetails(bytes32 _hash) public constant returns (string ,
                string,string,string,string,status,bytes32 ){
        return(pDetails[_hash].PlotNum,
        pDetails[_hash].regname,
        pDetails[_hash].currentowner,
        pDetails[_hash].previousowner,
        pDetails[_hash].ptype,
        pDetails[_hash].txnstatus,
        pDetails[_hash].prop_hash);//sha3_hash(_PlotNum);
     }
     
     
     function changeowner(bytes32 _hash,string _newowner)public returns (string,string,status ){
  //  
   require(pDetails[_hash].txnstatus == status.newproperty);
    
   pDetails[_hash].previousowner=pDetails[_hash].currentowner;
   pDetails[_hash].currentowner=_newowner;
   pDetails[_hash].txnstatus=status.ownerchanged;
   Changeowner(pDetails[_hash].previousowner,pDetails[_hash].currentowner,pDetails[_hash].txnstatus);
   return (pDetails[_hash].previousowner,pDetails[_hash].currentowner,pDetails[_hash].txnstatus);
   }
   
   string public oldregno;
   
     function registration(bytes32 _hash,string _regname)public returns (string,status ){
         
        require(pDetails[_hash].txnstatus == status.ownerchanged);
        require(pDetails[_hash].txnstatus != status.registered);
    
   oldregno = pDetails[_hash].regname;
   pDetails[_hash].regname= _regname;
   pDetails[_hash].txnstatus=status.registered;
   Registration(oldregno,pDetails[_hash].regname,pDetails[_hash].txnstatus);
   return (pDetails[_hash].regname,pDetails[_hash].txnstatus);
   }
   
     
   
   
   
}     