-- データと正常値リストを別DBにする。だがTriggerは同一テーブルしか参照できない。スキーマ名があるとエラーになる。
-- Error: trigger Validate_Insert_Names_Name cannot reference objects in database valid
attach ':memory:' as valid;
create table Names(Name text);
create table valid.Names_Name(Expected numeric primary key not null) without rowid;
insert into valid.Names_Name(Expected) values('A'),('B'),('C');

create trigger Validate_Insert_Names_Name before insert on Names
when not(select NEW.Name in (select Expected from valid.Names_Name))
begin
    select raise(ABORT, 'Invalid value. The Names.Name must match one of the Expected column values in the valid.Names_Name table.');
end;
