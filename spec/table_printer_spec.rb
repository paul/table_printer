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

end

