require 'csv'

libdir = File.expand_path("../lib", File.dirname(__FILE__))
$LOAD_PATH.unshift libdir
require "table_printer"
include TablePrinter

csv_file = File.join(File.dirname(__FILE__), "data.csv")

data = CSV.read(csv_file, headers: true, header_converters: :symbol, converters: :all)
          .map { |r| Hash[r.map { |c,r| [c,r] }] }

table = print_table(data) do
  column :name
  column :rate,      format: lambda { |s| "%0.2fop/s" % s }
  column :mean,      format: lambda { |s| "%0.2fms" % [s*1000] }
  column :stdev,     format: lambda { |s| "%0.3fms" % [s*1000] }
  column :min, :max, format: lambda { |s| "%0.2fms" % [s*1000] }
end

puts table

__END__
         name         |   rate   |    mean    |   stdev   |    min     |    max
 -------------------- | --------:| ----------:| ---------:| ----------:| ----------:
 Array of IDs (GIN)   | 0.70op/s |  1418.61ms |  25.521ms |  1383.80ms |  1470.74ms
 Array of Names (GIN) | 0.71op/s |  1400.85ms |  23.400ms |  1370.01ms |  1436.32ms
 HStore Names (GIN)   | 0.72op/s |  1392.08ms |  14.626ms |  1371.29ms |  1418.15ms
 HStore IDs (GIN)     | 0.71op/s |  1400.86ms |  17.447ms |  1377.21ms |  1432.88ms
 HStore IDs (GiST)    | 8.51op/s |   117.57ms |   3.804ms |   112.26ms |   129.64ms
 HStore Names (GiST)  | 2.04op/s |   489.36ms |  14.232ms |   474.02ms |   522.64ms
 Join Table           | 0.04op/s | 27501.62ms | 230.395ms | 27248.20ms | 27888.03ms
 Varchar              | 0.31op/s |  3213.08ms |  34.514ms |  3181.55ms |  3293.10ms
