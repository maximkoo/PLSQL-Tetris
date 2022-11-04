declare
  v_riddle t_riddle_table;
  v_still t_riddle_table:=t_riddle_table();
begin
  select new t_riddle(r.id, r.x, r.y) bulk collect into v_riddle from shapes r where r.shape_type_id=3;
  pck_riddle.print_shape(v_riddle);
  v_riddle:=pck_riddle.turn_left(v_riddle);
  pck_riddle.print_shape(v_riddle);
  v_riddle:=pck_riddle.turn_right(v_riddle);
  --v_riddle:=turn_right(v_riddle);
  pck_riddle.print_shape(v_riddle);
  --------
  v_still.extend();
  v_still(1):=new t_riddle(1,1,0);
  v_still.extend();
  v_still(2):=new t_riddle(2,2,0);
  v_still.extend();
  v_still(3):=new t_riddle(3,3,0);
  v_still.extend();
  v_still(4):=new t_riddle(4,4,0);
  v_still.extend();
  v_still(5):=new t_riddle(5,1,1);
  v_still.extend();
  v_still(6):=new t_riddle(6,2,1);
  v_still.extend();
  v_still(7):=new t_riddle(7,3,2);
  v_still.extend();
  v_still(8):=new t_riddle(8,4,2);
  dbms_output.put_line(pck_riddle.overlap(v_riddle,v_still));
  dbms_output.new_line;
  --find_still_lines(v_still);
  dbms_output.put_line('Drop time!');
  dbms_output.put_line('Before');
  pck_riddle.print_shape(v_still);
  --v_still:=drop_still_lines3(v_still);
  pck_riddle.drop_still_lines(v_still);
  dbms_output.put_line('After');
  pck_riddle.print_shape_data(v_still);
end;    
/
