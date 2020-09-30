.parameter set @value 'A'
select @value IN ('A','B','C'); /* 1 */
.parameter set @value 'X'
select @value IN ('A','B','C'); /* 0 */
