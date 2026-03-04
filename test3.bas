################################################################################################################################
## Name                                :  SMB_LAO_dataSubmit.scr
## Date                                :  13-11-2024
## Description                         :  LAO Data submit
## Author                              :  Thiwanka Randika
## Called Script                       :  NA
## Calling Script                      :  NA
## Reference                           :
## Modification History  :
## <Serial No.>      <Date>      <Author Name>                   <DESC>
## -----------        -----      -------------               -------------
##    1.0           13-11-2024   Thiwanka Randika            Original Version CCF - 241126
#################################################################################################################################

IMPORT LibCommon
IMPORT LibCommon1
IMPORT LibCommonB001
IMPORT LibCommonB002
IMPORT LibCommon5

SUB createRepClassB (fv_repName, fv_className)
#{
        IF (REPEXISTS(fv_repName) == 0) THEN
        #{
                CREATEREP (fv_repName)
        #}
        ENDIF

        IF (CLASSEXISTS(fv_repName,fv_className) == 0) THEN
        #{
                CREATECLASS (fv_repName,fv_className,5)
        #}
        ENDIF
#}
ENDSUB

SUB deleteRepClassB (fv_repName, fv_className)
#{
        IF (CLASSEXISTS(fv_repName,fv_className) == 1) THEN
        #{
                DELETECLASS (fv_repName,fv_className)
        #}
        ENDIF

        IF (REPEXISTS(fv_repName) == 1) THEN
        #{
                DELETEREP (fv_repName)
        #}
        ENDIF
#}
ENDSUB

SUB initAuditB()
#{
        sub_createRepClassB("AUDIT","OLD")
        sub_createRepClassB("AUDIT","NEW")
        sub_createRepClassB("AUDIT","KEY")
#}
ENDSUB

SUB delAuditB()
#{
        sub_deleteRepClassB("AUDIT","OLD")
        sub_deleteRepClassB("AUDIT","NEW")
        sub_deleteRepClassB("AUDIT","KEY")
#}
ENDSUB

SUB checkAuditModifyValue(fv_field)
#{
        IF(("AUDIT").("NEW").(fv_field) == ("AUDIT").("OLD").(fv_field)) THEN
        #{
                ("AUDIT").("NEW").(fv_field) = ""
                ("AUDIT").("OLD").(fv_field) = ""
        #}
        ENDIF
#}
ENDSUB

<--START
CHECKSUM="d3806e3c7f8d9615f46bd37627f56e757a25c77ff60514459eb50301824ade6a"
    
	TRACE ON

    # Creating repositories
    lv_u = urhk_B2k_PrintRepos("BANCS")
    PRINT(lv_u)

    IF(REPEXISTS("CUST")==0) THEN
    #{
            CREATEREP("CUST")
    #}
    ENDIF

    IF(CLASSEXISTS("CUST","LAO")==0) THEN
    #{
            CREATECLASS("CUST","LAO", 5)
    #}
    ENDIF
	
	CUST.LAO.error = ""
	CUST.LAO.custId = ""
	CUST.LAO.message = ""
	CUST.LAO.status = "N"
	CUST.LAO.seg1Date = ""
	CUST.LAO.seg2Date = ""
	CUST.LAO.seg3Date = ""
	CUST.LAO.bodDate = MID$(BANCS.STDIN.BODDate,0,10)
	CUST.LAO.updStat = "N"
	CUST.LAO.loanAmtFix = ""
	sv_p = "$TBA_PROD_ROOT/cust/01/INFENG/com/"
	CUST.LAO.accName = ""
	CUST.LAO.addl1 = ""
	CUST.LAO.addl2 = ""
	CUST.LAO.addl3 = ""
	CUST.LAO.cityCode = ""
	CUST.LAO.stateCode = ""
	CUST.LAO.loanRate = ""
	CUST.LAO.modSol = ""
	CUST.LAO.modCusId = ""
	CUST.LAO.modOperAcc = ""
	CUST.LAO.modPeriod = ""
	CUST.LAO.modLoanAmt = ""
	CUST.LAO.modSec = ""
	CUST.LAO.modSubSec = ""
	CUST.LAO.modCashSec = ""
	CUST.LAO.modUser = ""
	CUST.LAO.fiRecStatus = ""
	CUST.LAO.cusLoanAccount = ""
	CUST.LAO.cusNic = ""
	CUST.LAO.cusDob = ""
	CUST.LAO.cusMob = ""
	CUST.LAO.occuCode = ""
	CUST.LAO.cusOccue = ""
	CUST.LAO.prosFeeFix = ""
	CUST.LAO.emihidvalFix = ""
	CUST.LAO.ErrorDesc = ""
	CUST.LAO.ErrorSource = ""
	CUST.LAO.disburseMsg = ""
	CUST.LAO.empName = ""
	CUST.LAO.accSol = ""
	CUST.LAO.solDesc = ""
	CUST.LAO.schmType = ""
	CUST.LAO.domSol = ""
	
	IF(FIELDEXISTS(BANCS.INPUT.accNum)) THEN
	#{
		CUST.LAO.accNum = BANCS.INPUT.accNum
	#}
	ELSE
	#{
		CUST.LAO.accNum = ""
	#}
	ENDIF
	
	IF(FIELDEXISTS(BANCS.INPUT.loanAmt)) THEN
	#{
		CUST.LAO.loanAmt = BANCS.INPUT.loanAmt
	#}
	ELSE
	#{
		CUST.LAO.loanAmt = ""
	#}
	ENDIF
	
	IF(FIELDEXISTS(BANCS.INPUT.LoanPeriod)) THEN
	#{
		CUST.LAO.LoanPeriod = BANCS.INPUT.LoanPeriod
	#}
	ELSE
	#{
		CUST.LAO.LoanPeriod = ""
	#}
	ENDIF
	
	IF(FIELDEXISTS(BANCS.INPUT.secCode)) THEN
	#{
		CUST.LAO.secCode = BANCS.INPUT.secCode
	#}
	ELSE
	#{
		CUST.LAO.secCode = ""
	#}
	ENDIF
	
	IF(FIELDEXISTS(BANCS.INPUT.subSec)) THEN
	#{
		CUST.LAO.subSec = BANCS.INPUT.subSec
	#}
	ELSE
	#{
		CUST.LAO.subSec = ""
	#}
	ENDIF
	
	IF(FIELDEXISTS(BANCS.INPUT.cashFlow)) THEN
	#{
		CUST.LAO.cashFlow = BANCS.INPUT.cashFlow
	#}
	ELSE
	#{
		CUST.LAO.cashFlow = ""
	#}
	ENDIF
	
	IF(FIELDEXISTS(BANCS.INPUT.funcCode)) THEN
	#{
		CUST.LAO.funcCode = BANCS.INPUT.funcCode
	#}
	ELSE
	#{
		CUST.LAO.funcCode = ""
	#}
	ENDIF
	
	IF(FIELDEXISTS(BANCS.INPUT.prosFee)) THEN
	#{
		CUST.LAO.prosFee = BANCS.INPUT.prosFee
	#}
	ELSE
	#{
		CUST.LAO.prosFee = ""
	#}
	ENDIF
	
	IF(FIELDEXISTS(BANCS.INPUT.emihidval)) THEN
	#{
		CUST.LAO.emihidval = BANCS.INPUT.emihidval
	#}
	ELSE
	#{
		CUST.LAO.emihidval = ""
	#}
	ENDIF
	
	CUST.LAO.bodDate = MID$(BANCS.STDIN.BODDate,0,10)

	
	## -- Validations -- ##
	IF(CUST.LAO.funcCode == "A") THEN
	#{
		lv_a = urhk_getAcctDetailsInRepository(CUST.LAO.accNum)
		IF(lv_a == 0) THEN
		#{
			CUST.LAO.custId = BANCS.OUTPARAM.custId
			CUST.LAO.accName = BANCS.OUTPARAM.acctName
			PRINT(CUST.LAO.accName)
			CUST.LAO.accSol = BANCS.OUTPARAM.acctSolId
			CUST.LAO.schmType = BANCS.OUTPARAM.schmType
			
		#}
		ENDIF
		
		IF(CUST.LAO.schmType == "SBA") THEN
		#{
			CUST.LAO.schmType = "SAVINGS"
		#}
		ELSE
		#{
			CUST.LAO.schmType = "CURRENT"
		#}
		ENDIF
		
		IF(CUST.LAO.loanAmt != "") THEN
		#{
			lv_a = "loanAmtFix|SELECT TO_CHAR(TO_NUMBER(REPLACE('"+CUST.LAO.loanAmt+"', ',', '')), '999999999999999.99') AS formatVal FROM dual"
			lv_b = urhk_dbSelectWithBind(lv_a)
			IF(lv_b == 0) THEN
			#{
				CUST.LAO.loanAmtFix = BANCS.OUTPARAM.loanAmtFix
			#}
			ENDIF
		#}
		ENDIF
		
		IF(CUST.LAO.prosFee != "") THEN
		#{
			lv_a = "prosFeeFix|SELECT TO_CHAR(TO_NUMBER(REPLACE('"+CUST.LAO.prosFee+"', ',', '')), '999999999999999.99') AS formatVal FROM dual"
			lv_b = urhk_dbSelectWithBind(lv_a)
			IF(lv_b == 0) THEN
			#{
				CUST.LAO.prosFeeFix = BANCS.OUTPARAM.prosFeeFix
			#}
			ENDIF
		#}
		ENDIF
		
		IF(CUST.LAO.emihidval != "") THEN
		#{
			lv_a = "emihidvalFix|SELECT TO_CHAR(TO_NUMBER(REPLACE('"+CUST.LAO.emihidval+"', ',', '')), '999999999999999.99') AS formatVal FROM dual"
			lv_b = urhk_dbSelectWithBind(lv_a)
			IF(lv_b == 0) THEN
			#{
				CUST.LAO.emihidvalFix = BANCS.OUTPARAM.emihidvalFix
			#}
			ENDIF
		#}
		ENDIF
		
		CUST.LAO.modCnt = "0"
		lv_a = "modCnt|select count(1) from CUSTOM.PREAPPO_LOAN_MOD where OPER_FORACID = '"+CUST.LAO.accNum+"' and STATUS = 'P'"
		lv_b = urhk_dbSelectWithBind(lv_a)
		IF(lv_b == 0) THEN
		#{
			CUST.LAO.modCnt = BANCS.OUTPARAM.modCnt
		#}
		ENDIF
		
		IF(CINT(CUST.LAO.modCnt) > 0) THEN
		#{
			CUST.LAO.modSol = ""
			lv_a = "modSol|select SOL_ID from CUSTOM.PREAPPO_LOAN_MOD where OPER_FORACID = '"+CUST.LAO.accNum+"' and STATUS = 'P'"
			lv_b = urhk_dbSelectWithBind(lv_a)
			IF(lv_b == 0) THEN
			#{
				CUST.LAO.modSol = BANCS.OUTPARAM.modSol
			#}
			ENDIF
			
			CUST.LAO.error = "Pending Loan creation is exist. SOL ID - " + CUST.LAO.modSol
			GOTO ERROR
		#}
		ELSE
		#{
			IF(CUST.LAO.accNum != "") THEN
			#{
				CUST.LAO.eligLoanAmt = ""
				CUST.LAO.maxPeriod = ""
				CUST.LAO.expDate = ""
				lv_a = "eligLoanAmt,maxPeriod,expDate,domSol|select ELIG_LOANAMT,MAX_PERIOD,to_char(EXP_DATE,'dd-mm-yyyy'),DOM_BRANCH_CODE from custom.SMB_PRE_APP_PERSONL_LOAN_TABLE"
				lv_a = lv_a + " where OPER_ACC = '"+CUST.LAO.accNum+"' and nvl(REC_PRO_FLAG,'N')='N' and PRE_APP_FLAG = 'Y'"
				lv_b = urhk_dbSelectWithBind(lv_a)
				IF(lv_b == 0) THEN
				#{
					CUST.LAO.eligLoanAmt = BANCS.OUTPARAM.eligLoanAmt
					CUST.LAO.maxPeriod = BANCS.OUTPARAM.maxPeriod
					CUST.LAO.expDate = BANCS.OUTPARAM.expDate
					CUST.LAO.domSol = BANCS.OUTPARAM.domSol
				#}
				ELSE
				#{
					CUST.LAO.domSol = BANCS.STDIN.mySolId
				#}
				ENDIF
			#}
			ENDIF
						
			IF(cdouble(CUST.LAO.loanAmtFix) > cdouble(CUST.LAO.eligLoanAmt)) THEN
			#{
				CUST.LAO.error = "Loan amount cannot exceed the eligible loan amount."
				GOTO ERROR
			#}
			ELSE
			#{
				IF(CINT(CUST.LAO.LoanPeriod) > CINT(CUST.LAO.maxPeriod)) THEN
				#{
					CUST.LAO.error = "Period cannot exceed the maximum period allowed. Max period - " + CUST.LAO.maxPeriod
					GOTO ERROR
				#}
				ENDIF
			#}
			ENDIF
		#}
		ENDIF
		
		lv_c = "addl1,addl2,addl3,cityCode,stateCode|"
		lv_c = lv_c + "select ADDRESS_LINE1,ADDRESS_LINE2,ADDRESS_LINE3,CITY,STATE from CRMUSER.ADDRESS where orgkey = '"+CUST.LAO.custId+"' and ADDRESSCATEGORY = 'Mailing'"
		lv_d = urhk_dbSelectWithBind(lv_c)
		IF(lv_d == 0) THEN
		#{
			CUST.LAO.addl1 = BANCS.OUTPARAM.addl1
			CUST.LAO.addl2 = BANCS.OUTPARAM.addl2
			CUST.LAO.addl3 = BANCS.OUTPARAM.addl3
			CUST.LAO.cityCode = BANCS.OUTPARAM.cityCode
			CUST.LAO.stateCode = BANCS.OUTPARAM.stateCode
		#}
		ENDIF
		
		IF(CUST.LAO.cityCode != "") THEN
		#{
			lv_a = "addCity|select REF_DESC from tbaadm.rct where REF_REC_TYPE = '01' and REF_CODE = '"+CUST.LAO.cityCode+"' and DEL_FLG = 'N'"
			lv_b = urhk_dbSelectWithBind(lv_a)
			IF(lv_b == 0) THEN
			#{
				CUST.LAO.addCity = BANCS.OUTPARAM.addCity
			#}
			ENDIF
		#}
		ENDIF
		
		IF(CUST.LAO.stateCode != "") THEN
		#{
			lv_a = "addState|select REF_DESC from tbaadm.rct where REF_REC_TYPE = '02' and REF_CODE = '"+CUST.LAO.stateCode+"' and DEL_FLG = 'N'"
			lv_b = urhk_dbSelectWithBind(lv_a)
			IF(lv_b == 0) THEN
			#{
				CUST.LAO.addState = BANCS.OUTPARAM.addState
			#}
			ENDIF
		#}
		ENDIF
		
		IF(CUST.LAO.accNum != "") THEN
		#{
			lv_a = "loanRate|select LOAN_INT from CUSTOM.SMB_PRE_APP_PERSONL_LOAN_TABLE where OPER_ACC = '"+CUST.LAO.accNum+"' and nvl(REC_PRO_FLAG,'N') = 'N'"
			lv_b = urhk_dbSelectWithBind(lv_a)
			IF(lv_b == 0) THEN
			#{
				CUST.LAO.loanRate = BANCS.OUTPARAM.loanRate
			#}
			ENDIF
		#}
		ENDIF
		
		lv_a = "cusNic,cusDob,cusMob,occuCode|select NAT_ID_CARD_NUM,to_char(DATE_OF_BIRTH,'dd-mm-yyyy'),CUST_COMU_PHONE_NUM_2,CUST_OCCP_CODE FROM TABLE(CAST(custom.CMG_FUNC('"+CUST.LAO.custId+"')AS custom.CMG_TYPES))"
		lv_b = urhk_dbSelectWithBind(lv_a)
		IF(lv_b == 0) THEN
		#{
			CUST.LAO.cusNic = BANCS.OUTPARAM.cusNic
			CUST.LAO.cusDob = BANCS.OUTPARAM.cusDob
			CUST.LAO.cusMob = BANCS.OUTPARAM.cusMob
			CUST.LAO.occuCode = BANCS.OUTPARAM.occuCode
		#}
		ENDIF
		
		IF(CUST.LAO.occuCode != "") THEN
		#{
			lv_a = "cusOccue|select REF_DESC from tbaadm.rct where REF_CODE = '"+CUST.LAO.occuCode+"' and REF_REC_TYPE = '21' and DEL_FLG = 'N'"
			lv_b = urhk_dbSelectWithBind(lv_a)
			IF(lv_b == 0) THEN
			#{
				CUST.LAO.cusOccue = BANCS.OUTPARAM.cusOccue
			#}
			ENDIF
		#}
		ENDIF
		
		lv_a = "empName|select EMPLOYERSNAME from CRMUSER.DEMOGRAPHIC where ORGKEY = '"+CUST.LAO.custId+"'"
		lv_b = urhk_dbSelectWithBind(lv_a)
		IF(lv_b == 0) THEN
		#{
			CUST.LAO.empName = BANCS.OUTPARAM.empName
		#}
		ENDIF
		
		IF(CUST.LAO.accSol != "") THEN
		#{
			lv_a = "solDesc|select SOL_DESC from tbaadm.sol where SOL_ID = '"+CUST.LAO.accSol+"'"
			lv_b = urhk_dbSelectWithBind(lv_a)
			IF(lv_b == 0) THEN
			#{
				CUST.LAO.solDesc = BANCS.OUTPARAM.solDesc
			#}
			ENDIF
		#}
		ENDIF
		
		CUST.LAO.instDate = ""
		lv_a = "instDate|select TO_CHAR(CASE WHEN EXTRACT(DAY FROM TO_DATE('"+CUST.LAO.bodDate+"', 'dd-mm-yyyy')) <= 15 THEN TRUNC(TO_DATE('"+CUST.LAO.bodDate+"', 'dd-mm-yyyy'), 'MM') + INTERVAL '25' DAY"
		lv_a = lv_a + " ELSE TRUNC(TO_DATE('"+CUST.LAO.bodDate+"', 'dd-mm-yyyy'), 'MM') + INTERVAL '1' MONTH + INTERVAL '25' DAY END, 'DD-MM-YYYY') as outputDate from dual"
		lv_b = urhk_dbSelectWithBInd(lv_a)
		IF(lv_b == 0) THEN
		#{
			CUST.LAO.instDate = BANCS.OUTPARAM.instDate
			PRINT(CUST.LAO.instDate)
		#}
		ENDIF
	#}
	ENDIF
	
	## -- Submission -- ##
	
	IF(CUST.LAO.funcCode == "A") THEN
	#{
		BANCS.INPARAM.BINDVARS = ""
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + CUST.LAO.custId
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + "|A"
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + "|" + CUST.LAO.accNum
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + "|" + CUST.LAO.LoanPeriod
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + "|" + CUST.LAO.loanAmtFix
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + "|" + CUST.LAO.secCode
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + "|" + CUST.LAO.subSec
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + "|" + CUST.LAO.cashFlow
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + "|P"
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + "|" + CUST.LAO.bodDate
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + "|" + BANCS.STDIN.userId
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + "|" + BANCS.STDIN.mySolId
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + "|" + CUST.LAO.prosFeeFix
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + "|" + CUST.LAO.emihidvalFix
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + "|" + CUST.LAO.domSol
		PRINT(BANCS.INPARAM.BINDVARS)
		
		sv_a = "insert into CUSTOM.PREAPPO_LOAN_MOD(CUST_ID,FUNC_CODE,OPER_FORACID,LOAN_PERIOD,LOAN_AMT,SEC_CODE,SUB_SEC_CODE,CASHFLOW_SEC_CODE,STATUS,RCRE_TIME,RCRE_USER,SOL_ID,FREE_TEXT_1,FREE_TEXT_2,FREE_TEXT_3)"
		sv_a = sv_a + "values(?SVAR,?SVAR,?SVAR,?SVAR,?SVAR,?SVAR,?SVAR,?SVAR,?SVAR,to_date(?SVAR,'dd-mm-yyyy'),?SVAR,?SVAR,?SVAR,?SVAR,?SVAR)"
		sv_u = urhk_dbSQLWithBind(sv_a)
		IF(sv_u == 0) THEN
		#{
			CUST.LAO.updStat = "Y"
			
			sub_initAuditB()
			sv_z = urhk_InitAudit("")
			PRINT(sv_z)
            AUDIT.KEY.TABLEKEY              = BANCS.STDIN.mySolId + "/" + CUST.LAO.custId + "/" + CUST.LAO.accNum + "/" + CUST.LAO.LoanPeriod + "/" + CUST.LAO.loanAmtFix
            AUDIT.KEY.TABLEKEY              = AUDIT.KEY.TABLEKEY + "/" + CUST.LAO.secCode + "/" + CUST.LAO.subSec + "/" + CUST.LAO.cashFlow
            BANCS.INPARAM.TABLENAME         = "LAO"
            BANCS.INPARAM.AUTOVERIFY        = "N"
            BANCS.INPARAM.AUDITSOLID        = BANCS.STDIN.mySolId
            BANCS.INPARAM.excpnFlg          = "Y"
            BANCS.INPARAM.OPERCODE          = "A"
            BANCS.INPARAM.REFNUM            = ""
            BANCS.INPARAM.ACCTNUM       	= CUST.LAO.accNum
            BANCS.INPARAM.GLSUBHEADCODE 	= ""
            BANCS.INPARAM.MOPID         	= "LAO"
            sv_a = urhk_Audit("")
            PRINT(sv_a)
            sub_delAuditB()
			
			sv_k = CUST.LAO.accName + "|" + CUST.LAO.addl1 + "|" + CUST.LAO.addl2 + "|" + CUST.LAO.addl3 + "|" + CUST.LAO.addCity + "|"
			sv_k = sv_k + CUST.LAO.addState + "|" + CUST.LAO.loanAmtFix + "|" + CUST.LAO.LoanPeriod + "|" + CUST.LAO.loanRate + "|" + CUST.LAO.accNum + "|" + CUST.LAO.cusNic + "|" + CUST.LAO.cusDob + "|" + CUST.LAO.cusMob
			sv_k = sv_k + "|" + CUST.LAO.cusOccue + "|" + CUST.LAO.empName + "|" + CUST.LAO.solDesc + "|" + CUST.LAO.emihidval + "|" + CUST.LAO.schmType + "|" + CUST.LAO.instDate
			
			sv_s = sv_p + "SMB_LAO_appGen.com '" + sv_k + "'" + " " + BANCS.STDIN.userId
			
 			PRINT(sv_s)
			sv_a = SYSTEM(sv_s)
			PRINT(sv_a)
			IF(sv_a != 0) THEN
			#{
				CUST.LAO.updStat = "N"
			#}
			ENDIF
			
			
		#}
		ELSE
		#{
			CUST.LAO.updStat = "N"
		#}
		ENDIF
	#}
	ENDIF
	
	IF((CUST.LAO.funcCode == "V") OR (CUST.LAO.funcCode == "X")) THEN
	#{
		CUST.LAO.modInstAmt = 0.00
		lv_a = "modSol,modCusId,modOperAcc,modPeriod,modLoanAmt,modSec,modSubSec,modCashSec,modUser,modDomSol,modInstAmt|"
		lv_a = lv_a + "select SOL_ID,CUST_ID,OPER_FORACID,LOAN_PERIOD,to_char(LOAN_AMT,'999999999999999.99'),SEC_CODE,SUB_SEC_CODE,CASHFLOW_SEC_CODE,RCRE_USER,FREE_TEXT_3,FREE_TEXT_2 from CUSTOM.PREAPPO_LOAN_MOD"
		lv_a = lv_a + " where OPER_FORACID = '"+CUST.LAO.accNum+"' and STATUS = 'P' "
		lv_b = urhk_dbSelectWithBind(lv_a)
		IF(lv_b == 0) THEN
		#{
			CUST.LAO.modSol = BANCS.OUTPARAM.modSol
			CUST.LAO.modCusId = BANCS.OUTPARAM.modCusId
			CUST.LAO.modOperAcc = BANCS.OUTPARAM.modOperAcc
			CUST.LAO.modPeriod = BANCS.OUTPARAM.modPeriod
			CUST.LAO.modLoanAmt = BANCS.OUTPARAM.modLoanAmt
			CUST.LAO.modSec = BANCS.OUTPARAM.modSec
			CUST.LAO.modSubSec = BANCS.OUTPARAM.modSubSec
			CUST.LAO.modCashSec = BANCS.OUTPARAM.modCashSec
			CUST.LAO.modUser = BANCS.OUTPARAM.modUser
			CUST.LAO.modDomSol = BANCS.OUTPARAM.modDomSol
			CUST.LAO.modInstAmt = BANCS.OUTPARAM.modInstAmt
		#}
		ENDIF
		
		IF(CUST.LAO.funcCode == "V") THEN
		#{
			IF(CUST.LAO.modUser == BANCS.STDIN.userId) THEN
			#{
				CUST.LAO.error = "Same user cannot verify"
				GOTO ERROR
			#}
			ENDIF
		#}
		ENDIF
		
		lv_a = "loanRate|select LOAN_INT from CUSTOM.SMB_PRE_APP_PERSONL_LOAN_TABLE where OPER_ACC = '"+CUST.LAO.accNum+"' and nvl(REC_PRO_FLAG,'N') = 'N'"
		lv_b = urhk_dbSelectWithBind(lv_a)
		IF(lv_b == 0) THEN
		#{
			CUST.LAO.loanRate = BANCS.OUTPARAM.loanRate
		#}
		ENDIF
		
		BANCS.INPARAM.BINDVARS = "LAO|" + CUST.LAO.modSol + "/" + CUST.LAO.modCusId + "/" + CUST.LAO.modOperAcc + "/" + CUST.LAO.modPeriod + "/" + CUST.LAO.modLoanAmt + "/" + CUST.LAO.modSec
		BANCS.INPARAM.BINDVARS = BANCS.INPARAM.BINDVARS + "/" + CUST.LAO.modSubSec + "/" + CUST.LAO.modCashSec + "|" + CUST.LAO.modUser
		PRINT(BANCS.INPARAM.BINDVARS)
		
		CUST.LAO.auditRef = ""
		lv_c = "auditRef|select max(REF_NUM) from tbaadm.adt where TABLE_NAME = ?SVAR and TABLE_KEY = ?SVAR and ENTERER_ID = ?SVAR and AUTH_ID = '!' and FUNC_CODE = 'A' and BANK_ID = '01'"
		PRINT(lv_c)
		lv_d = urhk_dbSelectWithBind(lv_c)
		IF(lv_d == 0) THEN
		#{
			CUST.LAO.auditRef = BANCS.OUTPARAM.auditRef
			PRINT(CUST.LAO.auditRef)
		#}
		ELSE
		#{
			BANCS.INPUT.ErrorMesg = "Error in fetching record from Audit table."
		#}
		ENDIF
		
		IF(CUST.LAO.funcCode == "X") THEN
		#{
			CUST.LAO.pendingCnt = "0"
			lv_a = "pendingCnt|select count(1) from CUSTOM.PREAPPO_LOAN_MOD where OPER_FORACID = '"+CUST.LAO.accNum+"' and STATUS = 'P'"
			lv_b = urhk_dbSelectWithBind(lv_a)
			IF(lv_b == 0) THEN
			#{
				CUST.LAO.pendingCnt = BANCS.OUTPARAM.pendingCnt
			#}
			ENDIF
			
			IF(CINT(CUST.LAO.pendingCnt) > 0) THEN
			#{
				sv_a = "delete from CUSTOM.PREAPPO_LOAN_MOD where OPER_FORACID = '"+CUST.LAO.accNum+"' and STATUS = 'P'"
				sv_u = urhk_dbSQLWithBind(sv_a)
				IF(sv_u == 0) THEN
				#{
					CUST.LAO.updStat = "Y"
					
					sub_initAuditB()
					sv_z = urhk_InitAudit("")
					PRINT(sv_z)
					AUDIT.KEY.TABLEKEY              = CUST.LAO.modSol + "/" + CUST.LAO.modCusId + "/" + CUST.LAO.modOperAcc + "/" + CUST.LAO.modPeriod + "/" + CUST.LAO.modLoanAmt
					AUDIT.KEY.TABLEKEY              = AUDIT.KEY.TABLEKEY + "/" + CUST.LAO.modSec + "/" + CUST.LAO.modSubSec + "/" + CUST.LAO.modCashSec
					BANCS.INPARAM.TABLENAME         = "LAO"
					BANCS.INPARAM.AUTOVERIFY        = "N"
					BANCS.INPARAM.AUDITSOLID        = BANCS.STDIN.mySolId
					BANCS.INPARAM.excpnFlg          = "Y"
					BANCS.INPARAM.OPERCODE          = "X"
					BANCS.INPARAM.REFNUM            = CUST.LAO.auditRef
					BANCS.INPARAM.ACCTNUM       	= CUST.LAO.modOperAcc
					BANCS.INPARAM.GLSUBHEADCODE 	= ""
					BANCS.INPARAM.MOPID         	= "LAO"
					sv_a = urhk_Audit("")
					PRINT(sv_a)
					sub_delAuditB()
				#}
				ELSE
				#{
					CUST.LAO.updStat = "N"
				#}
				ENDIF
			#}
			ENDIF	
		#}
		ELSE
		#{
			IF(CUST.LAO.funcCode == "V") THEN
			#{
				CALL("SMB_LAO_loanOpenService.scr")
				CUST.LAO.fiRecStatus = CUST.LAO.fiRecStatus
				CUST.LAO.cusLoanAccount = CUST.LAO.loanAccNumber
				CUST.LAO.disburseMsg = CUST.LAO.disburseMsg
				PRINT(CUST.LAO.fiRecStatus)
				PRINT(CUST.LAO.cusLoanAccount)
				IF(CUST.LAO.fiRecStatus == "F") THEN
				#{
					CUST.LAO.updStat = "N"
					CUST.LAO.ErrorDesc = CUST.LAO.ErrorDesc
					CUST.LAO.ErrorSource = CUST.LAO.ErrorSource
				#}
				ELSE
				#{
					CUST.LAO.updStat = "Y"
					
					lv_n = "update CUSTOM.PREAPPO_LOAN_MOD set STATUS = 'V',LCHG_USER = '"+BANCS.STDIN.userId+"',LCHG_TIME = '"+CUST.LAO.bodDate+"',LOAN_FORACID = '"+CUST.LAO.cusLoanAccount+"'"
					lv_n = lv_n + " where OPER_FORACID = '"+CUST.LAO.accNum+"' and STATUS = 'P'"
					lv_p = urhk_dbSQLWithBind(lv_n)
					IF(lv_p == 0) THEN
					#{
						CUST.LAO.updStat = "Y"
						
						sv_a = "insert into CUSTOM.PREAPPO_LOAN_MAIN (select * from CUSTOM.PREAPPO_LOAN_MOD where OPER_FORACID = '"+CUST.LAO.accNum+"' and STATUS = 'V')"
						sv_u = urhk_dbSQLWithBind(sv_a)
						IF(sv_u == 0) THEN
						#{
							CUST.LAO.updStat = "Y"
							
							sv_a = "delete from CUSTOM.PREAPPO_LOAN_MOD where OPER_FORACID = '"+CUST.LAO.accNum+"' and STATUS = 'V'"
							sv_u = urhk_dbSQLWithBind(sv_a)
							IF(sv_u == 0) THEN
							#{
								CUST.LAO.updStat = "Y"
								
								sv_a = "update custom.SMB_PRE_APP_PERSONL_LOAN_TABLE set LOAN_OFFER_STSTUS = 'Y', LOAN_GRANTED_AMT = '"+CUST.LAO.modLoanAmt+"', LOAN_GRANTED_TENURE = '"+CUST.LAO.modPeriod+"',"
								sv_a = sv_a + "LOAN_GRANTED_DATE = to_date('"+CUST.LAO.bodDate+"','dd-mm-yyyy'),REC_PRO_FLAG = 'Y',LOAN_DISB_DATE = to_date('"+CUST.LAO.bodDate+"','dd-mm-yyyy')"
								sv_a = sv_a + " where OPER_ACC = '"+CUST.LAO.accNum+"' and nvl(REC_PRO_FLAG,'N') = 'N'"							
								sv_u = urhk_dbSQLWithBind(sv_a)
								IF(sv_u == 0) THEN
								#{
									CUST.LAO.updStat = "Y"
					
									sub_initAuditB()
									sv_z = urhk_InitAudit("")
									PRINT(sv_z)
									AUDIT.KEY.TABLEKEY              = CUST.LAO.modSol + "/" + CUST.LAO.modCusId + "/" + CUST.LAO.modOperAcc + "/" + CUST.LAO.modPeriod + "/" + CUST.LAO.modLoanAmt
									AUDIT.KEY.TABLEKEY              = AUDIT.KEY.TABLEKEY + "/" + CUST.LAO.modSec + "/" + CUST.LAO.modSubSec + "/" + CUST.LAO.modCashSec
									BANCS.INPARAM.TABLENAME         = "LAO"
									BANCS.INPARAM.AUTOVERIFY        = "N"
									BANCS.INPARAM.AUDITSOLID        = BANCS.STDIN.mySolId
									BANCS.INPARAM.excpnFlg          = "Y"
									BANCS.INPARAM.OPERCODE          = "V"
									BANCS.INPARAM.REFNUM            = CUST.LAO.auditRef
									BANCS.INPARAM.ACCTNUM       	= CUST.LAO.modOperAcc
									BANCS.INPARAM.GLSUBHEADCODE 	= ""
									BANCS.INPARAM.MOPID         	= "LAO"
									sv_a = urhk_Audit("")
									PRINT(sv_a)
									sub_delAuditB()
								#}
								ELSE
								#{
									CUST.LAO.updStat = "N"
								#}
								ENDIF
							#}
							ELSE
							#{
								CUST.LAO.updStat = "N"
							#}
							ENDIF
						#}
						ELSE
						#{
							CUST.LAO.updStat = "N"
						#}
						ENDIF
					#}
					ELSE
					#{
						CUST.LAO.updStat = "N"
					#}
					ENDIF
				#}
				ENDIF
			#}
			ENDIF
		#}
		ENDIF
	#}
	ENDIF
	
	IF(CUST.LAO.funcCode == "A") THEN
	#{
		IF(CUST.LAO.updStat == "Y") THEN
		#{
			CUST.LAO.message = "Record Successfully Added. Pls check HPR for the documents."
			GOTO SUCCESS
		#}
		ELSE
		#{
			CUST.LAO.error = "Record adding failed, Pls contact sys admin."
			GOTO ERROR
		#}
		ENDIF
	#}
	ELSE
	#{
		IF(CUST.LAO.funcCode == "X") THEN
		#{
			IF(CUST.LAO.updStat == "Y") THEN
			#{
				CUST.LAO.message = "Record Successfully cancelled."
				GOTO SUCCESS
			#}
			ELSE
			#{
				CUST.LAO.error = "Record cancellation failed, Pls contact sys admin."
				GOTO ERROR
			#}
			ENDIF
		#}
		ELSE
		#{
			IF(CUST.LAO.funcCode == "V") THEN
			#{
				IF(CUST.LAO.updStat == "Y") THEN
				#{
					CUST.LAO.message = "Record Successfully verified. Loan Opened successfully. Acc No - " + CUST.LAO.cusLoanAccount + " / " + CUST.LAO.disburseMsg
					GOTO SUCCESS
				#}
				ELSE
				#{
					CUST.LAO.error = "Record verification failed, Pls contact sys admin./" + CUST.LAO.ErrorDesc + "/" +CUST.LAO.ErrorSource
					GOTO ERROR
				#}
				ENDIF
			#}
			ENDIF
		#}
		ENDIF
	#}
	ENDIF
	
	SUCCESS:
	lv_a = urhk_dbSQLWithBind("COMMIT")
	lv_u = urhk_setOrbOut("RESULT_MSG|" + CUST.LAO.message)
	lv_m = urhk_SetOrbOut("SuccessOrFailure|Y")
	GOTO ENDOFSCRIPT
	
	ERROR:
	lv_a = urhk_dbSQLWithBind("ROLLBACK")
	CUST.LAO.errMsg = "Error_0|Error^" + CUST.LAO.error + "^dummy"
	lv_x = urhk_setOrbOut(CUST.LAO.errMsg)
	PRINT(lv_x)
	lv_u = urhk_SetOrbOut("SuccessOrFailure|N")
    GOTO ENDOFSCRIPT


	ENDOFSCRIPT:

	IF(CLASSEXISTS("CUST","LAO")==0) THEN
	#{
		DELETECLASS("CUST","LAO")
	#}
	ENDIF
	
	IF(REPEXISTS("CUST")==0) THEN
	#{
    	DELETEREP("CUST")
	#}
	ENDIF

#TRACE OFF

END-->
