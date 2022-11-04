require 'oci8'
oci = OCI8.new('c##maximko','Blank_stare45','XEPDB1')
#oci.exec('select shape_type_code from shape_types') do |record|
#  puts record.join(',')
#end

oci.exec('select demitasse.get_shape_xml from dual') do |record|
  puts record  
end;	