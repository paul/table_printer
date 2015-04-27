require 'time'

libdir = File.expand_path("../lib", File.dirname(__FILE__))
$LOAD_PATH.unshift libdir
require "table_printer"
include TablePrinter

data = [
  {
    user:         "paul",
    name:         "Paul Sadauskas",
    repos:        42,
    signed_up_at: Time.iso8601("2008-11-01T08:42:30Z"),
    commit_rate:  1000.0 / 365,
    repo_size:    3.14 * 1024**2

  }
]

puts print_table(data) {
  column :user, :name, :repos
  column :signed_up_at, title: "Signed up"
  column :commit_rate, format: "%0.4f"
  column :repo_size, format: :bytes
}

__END__

 user |      name      | repos |        Signed up        | commit_rate | repo_size
 ---- | -------------- | -----:| ----------------------- | -----------:| ---------:
 paul | Paul Sadauskas |    42 | 2008-11-01 08:42:30 UTC |      2.7397 |  3.14 MiB
