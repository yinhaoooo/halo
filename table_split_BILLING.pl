open(INPUT, "t_BILLING.sql");
open(OUTPUT, ">", "billing_table.sql");
open(OUTPUT2, ">", "billing_constraints.sql");
open(OUTPUT3, ">", "billing_index.sql"); 
while(<INPUT>){
  $str.=$_
}

@index=$str=~/CREATE\s*(?:UNIQUE)?\s*INDEX\s+\w+\s+ON[^\n]*;\n/igm;
@constraint=$str=~/ALTER\s*TABLE[^\n]*;\n/igm;

$str=~s/CREATE\s*(?:UNIQUE)?\s*INDEX\s+\w+\s+ON[^\n]*;\n//igm;
$str=~s/ALTER\s*TABLE[^\n]*;\n//igm;
print OUTPUT3 @index;
print OUTPUT2 @constraint;

print OUTPUT $str;

