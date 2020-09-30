create table Names(Name text);
create table Names_Name_VV(Expected numeric primary key not null) without rowid;
insert into Names_Name_VV(Expected) values('A'),('B'),('C');

create trigger Validate_Insert_Names_Name before insert on Names
when not(select NEW.Name in (select Expected from Names_Name_VV))
begin
    select raise(ABORT, 'Invalid value. The Names.Name must match one of the Expected column values in the Names_Name_VV table.');
end;
create trigger Validate_Update_Names_Name before update on Names
when not(select NEW.Name in (select Expected from Names_Name_VV))
begin
    select raise(ABORT, 'Invalid value. The Names.Name must match one of the Expected column values in the Names_Name_VV table.');
end;

insert into Names values('X');
insert into Names values('A');
select * from Names;
update Names set Name = 'X';
select * from Names;
update Names set Name = 'B';
select * from Names;
