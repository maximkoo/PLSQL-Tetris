create or replace package PCK_RIDDLE is
--pragma serially_reusable;

  -- Author  : MAX
  -- Created : 30.10.2022 18:55:51
  -- Purpose : Riddle project
  
  function get_initial_xml return varchar2;
  procedure main_loop;
  procedure tick;
  procedure read_shapes;
  procedure turn_left;
  procedure turn_right;
  procedure move_left;
  procedure move_right;
  procedure print_shape(p_shape t_riddle_table) ;
  procedure print_shape_data(p_shape t_riddle_table);
  function overlap(p_shape t_riddle_table, p_still t_riddle_table) return integer;
  procedure drop_still_lines(p_still in out t_riddle_table) ;
  procedure fall;
  procedure set_shape;
  function get_gameplay_xml return varchar2;
  
   -- function getXX return int;
  
end PCK_RIDDLE;
/
create or replace package body PCK_RIDDLE is
--pragma serially_reusable;

  v_riddle t_riddle_table;
  v_still t_riddle_table:=t_riddle_table();
  
  v_shapes t_shapes:=t_shapes();
  
  XX int:=1;
  YY int:=0;
  
  LEFT_BORDER constant int:=0;
  RIGHT_BORDER constant int:=10;
  BOTTOM constant int:=20;
  
  function get_initial_xml return varchar2
    is 
    res varchar2(1000);
    begin
      select xmlelement("initial", 
                        xmlelement("width",RIGHT_BORDER-LEFT_BORDER),
                        xmlelement("height",BOTTOM),
                        xmlelement("frame-delay",250)
                       ).getStringVal()
        into res
        from dual;              
      
      return res;
    end;
  
  procedure main_loop
  is
  v_ts timestamp:=systimestamp;
  v_tact number:=1; --0.1;
  begin
    loop
      if systimestamp>v_ts+v_tact*interval '1' second then
        dbms_output.put_line(systimestamp);
        fall();
        dbms_output.put_line(get_gameplay_xml);
        v_ts:=systimestamp;
      end if;
    end loop;
  end;
  
  procedure tick
    is
    begin
      fall();
    end;  
      
  
  procedure read_shapes
  is
  --c int:=0;
    v_shape t_riddle_table;
  begin
    for i in (select * from shape_types order by 1)
      loop
        select new t_riddle(sh.id, sh.x, sh.y)
          bulk collect into v_shape
          from shapes sh
         where sh.shape_type_id=i.shape_type_id;
        v_shapes.extend;
        v_shapes(v_shapes.count):=v_shape;
        dbms_output.put_line(i.shape_type_code||' read');
      end loop;
      v_still.extend(1);
    v_still(v_still.count):=new t_riddle(1,10,10);
  end;
  
  function random_shape return t_riddle_table
  is
  i int;
  begin
    i:=3;
    return v_shapes(i);
  end;  
  
  procedure set_shape
    is
    begin
      dbms_output.put_line('The shape is set');
      v_riddle:=random_shape();
    end;
  
  procedure fall
  is
  begin
    YY:=YY+1;  
  end;
  
  procedure turn_left
    is
    v_boxsize int:=3;
    --v_shape t_riddle_table;
    begin
      select new t_riddle(qq.id, qq.y, v_boxsize-qq.x) 
        bulk collect into v_riddle
        from (select value(q).id as id, value(q).x as x, value(q).y as y from table(v_riddle) q) qq;
    --return v_shape;    
    end;  
    
  procedure turn_right
    is
    v_boxsize int:=3;
    --v_shape t_riddle_table;
    begin
      select new t_riddle(qq.id, v_boxsize-qq.y, qq.x) 
        bulk collect into v_riddle
        from (select value(q).id as id, value(q).x as x, value(q).y as y from table(v_riddle) q) qq;
    --return v_shape;    
    end;  
  
/*  function getXX return int
    is
    begin
      return XX;
    end; */   
    
  procedure move_left
    is
    begin
      XX:=XX-1;
    end;  
    
  procedure move_right
    is
    begin
      XX:=XX+1;
      end;  
    
  procedure print_shape(p_shape t_riddle_table) 
    is
    type t_line is table of char(1);
    v_line t_line:=t_line();
    v_str varchar2(100);
    c int:=0;
    begin
      v_line.extend(16);
      for i in (select value(q).id as id, value(q).x as x, value(q).y as y from table(p_shape) q)
        loop
          v_line(i.y*4+i.x+1):='X';
        end loop;
      
      for i in v_line.first..v_line.last loop
         v_str:=v_str||nvl(v_line(i),' ');
         c:=c+1;
         --if c=4 then v_str:=v_str||chr(13); c:=0; /*dbms_output.put_line(1);*/end if;
         if c=4 then dbms_output.put_line(v_str); c:=0; v_str:=''; end if;
      end loop;
      --dbms_output.put_line(v_str);
      dbms_output.new_line();
    end;
    
  procedure print_shape_data(p_shape t_riddle_table) 
    is
    begin
      for i in (select value(q).id as id, value(q).x as x, value(q).y as y from table(p_shape) q)
        loop
          dbms_output.put_line(i.id||' '||i.x||' '||i.y);                    
        end loop;
        dbms_output.new_line(); 
     end;   
     
  function overlap(p_shape t_riddle_table, p_still t_riddle_table) return integer
    is
    res integer;
    begin
      with shape as (select value(q).id as id, value(q).x as x, value(q).y as y from table(p_shape) q),
           still as (select value(q).id as id, value(q).x as x, value(q).y as y from table(p_still) q)
      select count(*) into res 
       from dual where exists
       (select * from shape sh
        inner join still st
           on sh.x=st.x
          and sh.y=st.y);
      return res;    
    end;   
    
  function hit_left(p_shape t_riddle_table) return integer
    is
    begin
      for i in (with sh as (select value(q).id as id, value(q).x as x, value(q).y as y from table(p_shape) q) 
                 select count(*) as cnt from dual
                  where exists(select sh.* from sh where sh.x<=LEFT_BORDER)
                )
      loop
        return i.cnt;
      end loop;      
    end;   

  function hit_right(p_shape t_riddle_table) return integer
    is
    begin
      for i in (with sh as (select value(q).id as id, value(q).x as x, value(q).y as y from table(p_shape) q) 
                 select count(*) as cnt from dual
                  where exists(select sh.* from sh where sh.x>=RIGHT_BORDER)
                )
      loop
        return i.cnt;
      end loop;      
    end;    
       
  procedure drop_still_lines(p_still in out t_riddle_table) 
    is
    v_still t_riddle_table:=p_still;
    begin
      with w as (select level-1 as x from dual connect by level<=10),
           h as (select level-1 as y from dual connect by level<=10),
           still as (select value(q).id as id, value(q).x as x, value(q).y as y from table(v_still) q)
      select new t_riddle(s.id, s.x, s.y)
        bulk collect into p_still
        from still s
        where s.y not in
      (
      select q.y
        from (
      select st.y, count(st.x) as xcnt
       from w cross join h
      inner join still st
         on st.x=w.x
        and st.y=h.y
      group by st.y
      order by st.y) q
      where q.xcnt=4); 
  end; 
  
  function get_gameplay_xml return varchar2
  is
  res varchar2(3000);
  begin
    with sh as (select value(q).id as id, value(q).x as x, value(q).y as y from table(v_riddle) q),
         st as (select value(q).id as id, value(q).x as x, value(q).y as y from table(v_still) q)
    
    select xmlelement("gameplay",
                      xmlagg(q.val)).getStringVal()
    into res
    from (
    
    select xmlelement("shape",
                      xmlelement("x",XX), 
                      xmlelement("y",YY), 
                      xmlelement("blocks",
                                  xmlagg(
                                          xmlelement("block", xmlattributes(sh.x, sh.y))
                                        )
                                )
                     ) as val
      from sh
      
      UNION ALL
      
      select xmlelement("still",
                        xmlelement("blocks",
                                  xmlagg(
                                          xmlelement("block", xmlattributes(st.x, st.y))
                                        )
                                )
                        ) as val
      from st    
      ) q;              
    return res;  
  end;     
    
begin
  null;
end PCK_RIDDLE;
/
