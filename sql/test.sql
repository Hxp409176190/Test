select loan.id "id", loan.publish_date "publishDate"
  from bao_t_auto_publish_info a, bao_t_loan_info loan
 inner join BAO_T_LOAN_DETAIL_INFO d
    on d.loan_id = loan.id
 inner join bao_t_audit_info au
    on au.relate_primary = loan.id
 where loan.loan_status = '待发布'
   and loan.attachment_flag = '已完成'
   and loan.NEWER_FLAG != '新手标'
   and au.apply_type = '优选项目审核'
   and au.AUDIT_STATUS = '通过'
   and loan.LOAN_TERM * decode(loan.LOAN_UNIT, '天', 1, '月', 30, 1) >= 30
   and loan.LOAN_TERM * decode(loan.LOAN_UNIT, '天', 1, '月', 30, 1) <= 90
   and d.year_irr between 0.03 and 0.12
   and loan.rasie_days between 3 and 5
   and loan.loan_amount between 100 and 10000
   and (loan.repayment_method = '等额本息' OR loan.repayment_method = '到期还本付息' OR
       loan.repayment_method = '每期还息到期付本')
   and loan.debt_source_code = 'NMJR'
 order by au.audit_time asc,
          decode(loan.debt_source_code, 'SXSW', 1, 'SXRZ', 2, 99);
