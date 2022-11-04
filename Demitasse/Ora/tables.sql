---------------------
-- Список цветов
/*
NONE = Gosu::Color.argb(0x00_000000)
BLACK = Gosu::Color.argb(0xff_000000)
GRAY = Gosu::Color.argb(0xff_808080)
WHITE = Gosu::Color.argb(0xff_ffffff)
AQUA = Gosu::Color.argb(0xff_00ffff)
RED = Gosu::Color.argb(0xff_ff0000)
GREEN = Gosu::Color.argb(0xff_00ff00)
BLUE = Gosu::Color.argb(0xff_0000ff)
YELLOW = Gosu::Color.argb(0xff_ffff00)
FUCHSIA = Gosu::Color.argb(0xff_ff00ff)
CYAN = Gosu::Color.argb(0xff_00ffff)
*/

create table shape_colors
(color_id int not null,
 color_code varchar2(20) not null,
 color_hex varchar2(20) not null);
 
alter table riddle.shape_colors add constraint shape_color_pk primary key (color_id); 

comment on table riddle.shape_types is 'Цвета'; 

---------------------
-- Список типов фигур
create table riddle.shape_types 
(shape_type_id int not null,
 shape_type_code varchar2(10) not null,
 shape_type_name varchar2(100),
 shape_color int not null);
 
alter table riddle.shape_types add constraint shape_type_pk primary key (shape_type_id); 
alter table riddle.shape_types add constraint shape_type_color_fk foreign key (shape_color) references riddle.shape_colors(color_id);

comment on table riddle.shape_types is 'Типы фигур';

------------------------------------
-- Сами фигуры с координатами блоков
create table riddle.shapes
(shape_type_id int not null,
 id int not null,
 x int not null,
 y int not null);

alter table riddle.shapes add constraint shape_type_fk foreign key (shape_type_id) referencing shape_types(shape_type_id);

comment on table riddle.shapes is 'Фигуры';


--------------------
-- Заполнение таблиц
delete from riddle.shape_colors;

insert all 
into shape_colors(color_id, color_code, color_hex)
values(1,'NONE','0x00_000000')
into shape_colors(color_id, color_code, color_hex)
values(2,'BLACK','0xff_000000') -- 0xff обозначает, что цвет совершенно не прозрачный, 0x80 - полупрозрачный, 0x00 - прозрачный
into shape_colors(color_id, color_code, color_hex)
values(3,'GRAY','0xff_808080')
into shape_colors(color_id, color_code, color_hex)
values(4,'WHITE','0xff_ffffff')
into shape_colors(color_id, color_code, color_hex)
values(5,'AQUA','0xff_00ffff')
into shape_colors(color_id, color_code, color_hex)
values(6,'RED','0xff_ff0000')
into shape_colors(color_id, color_code, color_hex)
values(7,'GREEN','0xff_00ff00')
into shape_colors(color_id, color_code, color_hex)
values(8,'BLUE','0xff_0000ff')
into shape_colors(color_id, color_code, color_hex)
values(9,'YELLOW','0xff_ffff00')
into shape_colors(color_id, color_code, color_hex)
values(10,'FUCHSIA','0xff_ff00ff')
into shape_colors(color_id, color_code, color_hex)
values(11,'CYAN','0xff_00ffff')
select 1 from dual;

delete from riddle.shape_types;
insert all into riddle.shape_types(shape_type_id, shape_type_code, shape_type_name, shape_color)
           values(1,'Stick',null, 9)
           into riddle.shape_types(shape_type_id, shape_type_code, shape_type_name, shape_color)
           values(2,'Cube',null, 6)
           into riddle.shape_types(shape_type_id, shape_type_code, shape_type_name, shape_color)
           values(3,'T-Shape',null, 11)
           into riddle.shape_types(shape_type_id, shape_type_code, shape_type_name, shape_color)
           values(4,'L-Shape1',null, 8)
           into riddle.shape_types(shape_type_id, shape_type_code, shape_type_name, shape_color)
           values(5,'L-Shape2',null, 7)
           into riddle.shape_types(shape_type_id, shape_type_code, shape_type_name, shape_color)
           values(6,'Z-Shape1',null, 3)
           into riddle.shape_types(shape_type_id, shape_type_code, shape_type_name, shape_color)
           values(7,'Z-Shape2',null, 10)
select 1 from dual;

delete from riddle.shapes;
insert all into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,1, 1,0)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,2, 1,1)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,3, 1,2)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,4, 1,3)
select * from riddle.shape_types sh where sh.shape_type_code='Stick';

insert all into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,1, 1,1)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,2, 2,1)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,3, 1,2)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,4, 2,2)
select * from riddle.shape_types sh where sh.shape_type_code='Cube';

insert all into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,1, 1,0)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,2, 1,1)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,3, 2,1)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,4, 1,2)
select * from riddle.shape_types sh where sh.shape_type_code='T-Shape';

insert all into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,1, 1,0)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,2, 2,0)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,3, 2,1)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,4, 2,2)
select * from riddle.shape_types sh where sh.shape_type_code='L-Shape1';

insert all into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,1, 1,0)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,2, 2,0)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,3, 2,1)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,4, 2,2)
select * from riddle.shape_types sh where sh.shape_type_code='L-Shape2';

insert all into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,1, 0,1)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,2, 1,1)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,3, 1,2)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,4, 2,2)
select * from riddle.shape_types sh where sh.shape_type_code='Z-Shape1';

insert all into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,1, 1,2)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,2, 2,1)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,3, 2,2)
           into riddle.shapes(shape_type_id,id,x,y) values(shape_type_id,4, 3,1)
select * from riddle.shape_types sh where sh.shape_type_code='Z-Shape2';

select * from riddle.shapes order by 1;
