create table ValidateValues(Value numeric primary key not null) without rowid;
insert into ValidateValues(Value) values('A'),('B'),('C');
.parameter set @value 'A'
select @value IN (select Value from ValidateValues); /* 1 */
.parameter set @value 'X'
select @value IN (select Value from ValidateValues); /* 0 */
