-- トリガーは変数を使えない。
-- Error: trigger cannot use variables
create table Names(Name text);
create table Names_Name_VV(Expected numeric primary key not null) without rowid;
insert into Names_Name_VV(Expected) values('A'),('B'),('C');

.param set @actual 'X'
create trigger Validate_Insert_Names_Name before insert on Names
when not(select @actual in (select Expected from Names_Name_VV))
begin
    select raise(ABORT, 'Invalid value. The Names.Name must match one of the Expected column values in the Names_Name_VV table.');
end;

--.param set @actual 'X'
--insert into Names values(@actual);
--.param set @actual 'A'
--insert into Names values(@actual);
--select * from Names;
