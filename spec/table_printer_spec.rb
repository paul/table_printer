require "spec_helper"

describe TablePrinter do

  let(:test_module) { Module.new { extend TablePrinter } }

  let(:data) do
    [
      {user: "paul", repos: 42, score: 3.14},
      {user: "peter", repos: 17, score: 1.414}
    ]
  end

  it "should work" do
    output = test_module.print_table(data)
    expect(output).to_not be_empty
  end

  describe TablePrinter::Table::Column do
    let(:options) { {} }
    let(:name) { "name" }
    let(:column) { TablePrinter::Table::Column.new(name, options) }

    describe "formatting values with the :format option" do
      subject(:formatted_value) { column.values << value; column.formatted_values.first }

      context "when unset" do
        let(:options) { {} }

        context "when value is a string" do
          let(:value) { "test" }
          it { should == "test" }
        end

        context "when value is an int" do
          let(:value) { 42 }
          it { should == value.to_s }
        end

        context "when value is a float" do
          let(:value) { 1.0 / 3.0 }
          it { should == value.to_s }
        end
      end

      context "when formatting string" do
        let(:options) { {format: "test %0.2f"} }
        let(:value) { 3.1415 }
        it { should == "test 3.14" }
      end

      context "when :percent" do
        let(:options) { {format: :percent} }
        let(:value) { 0.9090 }
        it { should == "90.9%" }
      end

      context "when :bytes" do
        let(:options) { {format: :bytes} }
        let(:value) { 1024**3 }
        it { should == "1.0 GiB" }
      end

      context "when :time" do
        let(:options) { {format: :time} }
        let(:value) { Time.at(1404074851) }
        it { should == "2014-06-29T20:47:31Z" }
      end

      context "when :duration" do
        let(:options) { {format: :duration} }
        let(:value) { 129690 }
        it { should == "36:01:30" }
      end

      context "when Proc" do
        let(:options) { {format: lambda { |v| v.to_s.reverse } } }
        let(:value) { 42 }
        it { should == "24" }
      end
    end

    describe "justified values" do
      subject(:justified_values) { column.values << value; column.justified_values.first }

      context "when values are all strings" do
        let(:value) { "t" }
        it { should == "t   " }
      end

      context "when values are all numbers" do
        let(:value) { 2 }
        it { should == "   2" }
      end

      context "when overridden by option" do
        let(:options) { {justify: "right"} }
        let(:value) { "tt" }
        it { should == "  tt" }
      end

      describe "the markdown header line" do
        subject(:separator) { column.separator }
        let(:value) { "t" }

        context "when left-justified" do
          let(:options) { {justify: "left"} }
          it { should == " ---- " }
        end

        context "when center-justified" do
          let(:options) { {justify: "center"} }
          it { should == ":----:" }
        end

        context "when right-justified" do
          let(:options) { {justify: "right"} }
          it { should == " ----:" }
        end
      end
    end

  end

end

