require 'oci8'
require 'gosu'
require 'nokogiri'

class GetOCI
    def initialize
        @oci = OCI8.new('riddle','riddle','XEPDB1')
    end;    

    def oci
        @oci
    end;    
end; 

#FRAME_DELAY=250
BLOCK_SIZE=20

class GameWindow<Gosu::Window    
    SCREEN_WIDTH=Gosu.screen_width;
    SCREEN_HEIGHT=Gosu.screen_height;
    attr_reader :oci     
    def initialize          
        #@xx=1
        #@yy=0
        $window_width=600
        $window_height=600;
        @red20=Gosu::Image.new('red20.png');
        
        @objectPool=ObjectPool.new();
        @oci=GetOCI.new.oci();
        @oci.exec('begin riddle.pck_riddle.read_shapes(); end;');
        @oci.exec('begin riddle.pck_riddle.set_shape(); end;');
        @oci.exec('select riddle.pck_riddle.get_initial_xml() from dual') do |record|
            a=record[0]  
            #puts a          
            b=Nokogiri::XML(a)
            @frame_delay=b.xpath('/initial/frame-delay/text()').to_s.to_i
            @width=b.xpath('/initial/width/text()').to_s.to_i  
            @height=b.xpath('/initial/height/text()').to_s.to_i  
        end;
        #b=getXML
        #shape=Shape.new do |i, b|
        #    i.setBlocks(b)
        #end;
        @shape=Shape.new(self)
        #@shape.master=self

        super($window_width,$window_height, true)       
    end;

    def needs_cursor?
        true
    end 
  
    def button_down(id)
        if id==Gosu::KbEscape
            close       
        end;

        if id==Gosu::KbRight            
            @oci.exec('begin riddle.pck_riddle.move_right(); end;');       
            #getXML();
            @shape.move
        end;

        if id==Gosu::KbLeft
            @oci.exec('begin riddle.pck_riddle.move_left(); end;'); 
            #getXML();
            @shape.move
        end;        

        if id==Gosu::KbUp
            @oci.exec('begin riddle.pck_riddle.turn_right(); end;'); 
            #getXML();
            @shape.turn
        end; 
    end;

    # def move_shape
    #     b=getXML
    #     @xx=b.xpath('/gameplay/shape/x/text()').to_s.to_i
    #     @yy=b.xpath('/gameplay/shape/y/text()').to_s.to_i
    # end
    
    # def turn_shape
    #     b=getXML
    #     shapeXML=b.xpath('/gameplay/shape/blocks/block');
    #     shapeXML.each do |i|
    #         puts "#{i.attributes['X']} #{i.attributes['X']}" #--------<<!!!


    #     end;    
    # end;           

    def update
        now=Gosu.milliseconds
        return if (now-@last_update||=now) < @frame_delay
        #@objectPool.objects.map(&:update);     
        @oci.exec('begin riddle.pck_riddle.tick(); end;');  
        #getXML();
        #move_shape;
        @shape.move
        
        @last_update=now;
    end;

    def draw
        @objectPool.objects.map(&:draw)   
        #@red20.draw(@xx*BLOCK_SIZE, @yy*BLOCK_SIZE,0)
        draw_rect(@shape.xx*BLOCK_SIZE, @shape.yy*BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, Gosu::Color.argb(0xff_ff0000), 0);
        #@objectPool.draw()  
    end;
end;  

class Cube
    attr_accessor :x, :y, :img
    def initialize(x,y,img)
        @x,@y,@img=x,y,img
    end; 

    def draw
        @img.draw(x*BLOCK_SIZE, y*BLOCK_SIZE, 10)
    end;   
end;

class Shape
    attr_accessor :master, :blocks, :xx, :yy
    #def initialize(i, b)      
    #    @blocks=[]
    #    yield(self, b)
    #end;
    #blocks<<{x:0, y:0}
    def initialize(master)
        @master=master
        @blocks=[]
        @b=getXML
        setBlocks(@b)
        @xx=1
        @yy=0
    end;    

    def draw
        
    end; 

    def getXML
        @master.oci.exec('select riddle.pck_riddle.get_gameplay_xml from dual') do |record|
            puts record[0]
            #puts record.class.name
            a=record[0]  
            #puts a          
            #b=Nokogiri::XML(a)
            b=Nokogiri::XML.parse(a); 
            #puts @xx, @yy             
            return b
        end; 
    end;   

    def setBlocks(b)
        @blocks.clear()
        shapeXML=b.xpath('/gameplay/shape/blocks/block');
        shapeXML.each do |i|
            puts "#{i.attributes['X']} #{i.attributes['X']}" #--------<<!!!
            @blocks<<{x:i.attributes['X'], y:i.attributes['Y']}
        end    
    end;  
    
    def move
        b=getXML
        @xx=b.xpath('/gameplay/shape/x/text()').to_s.to_i
        @yy=b.xpath('/gameplay/shape/y/text()').to_s.to_i
    end 

    def turn

    end;  
end;    

class ObjectPool
    attr_accessor :objects
    def initialize
        @objects=[]
        @gray20=Gosu::Image.new('gray20.png');
        (0..19).each do |i|
            @objects<<Cube.new(0,i,@gray20)
            @objects<<Cube.new(10,i,@gray20)
        end; 
        (0..10).each do |i|
            @objects<<Cube.new(i,20,@gray20)
        end;    
    end;

    # def draw
    #    #draw_quad(x-size, y-size, 0xffffffff, x+size, y-size, 0xffffffff, x-size, y+size, 0xffffffff, x+size, y+size, 0xffffffff, 0)
    #    @objects.each do |obj|
    #         #puts obj.img
    #         obj.img.draw(obj.x*BLOCK_SIZE, obj.y*BLOCK_SIZE,10)
    #    end 
    # end;    
end;    

$g=GameWindow.new
$g.show;  

#oci=GetOCI.new.oci();

  # oci.exec('begin riddle.pck_riddle.read_shapes(); end;');
  # oci.exec('begin riddle.pck_riddle.set_shape(); end;');

  # t = Thread.new do
  #   #while true do
  #       oci.exec('begin riddle.pck_riddle.main_loop(); end;');  
  #   #end
  # end

# i=0
# t1 = Time.now
# while (i<50) do
#     t2 = Time.now
#     if (t2-t1)*1000.0 > 250
#         oci.exec('begin riddle.pck_riddle.tick(); end;');
#         oci.exec('select riddle.pck_riddle.get_shape_xml from dual') do |record|
#             puts record  
#             t1=Time.now      
#         end;
#         puts i;
#         i=i+1
#     end;
# end;


# oci.exec('select riddle.pck_riddle.get_shape_xml from dual') do |record|
#             puts record  
#             t1=Time.now      
#         end;

#          t.join

# def time_diff_milli(start, finish)
#    (finish - start) * 1000.0
# end

# t1 = Time.now
# # arbitrary elapsed time
# t2 = Time.now
# msecs = time_diff_milli t1, t2