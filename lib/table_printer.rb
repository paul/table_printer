require "table_printer/version"

module TablePrinter

  def print_table(data, io=$stdout, &config)
    io.puts Table.new(&config).render(data)
  end

  class Table
    attr_reader :columns, :data

    def initialize(data = [], &block)
      @data = data
      @columns = []
      instance_eval &block if block_given?
    end

    def column(*names)
      options = names.extract_options!
      names.each do |name|
        columns << Column.new(name, options)
      end
    end

    def render(data = @data)
      data.each do |row|
        if row.respond_to? :keys
          row.each do |name, value|
            columns.detect { |col| col.name == name } << value
          end
        else
          row.each.with_index do |value, i|
            columns[i << value
          end
        end
      end

      str = ""
      if columns.any? { |col| col.has_header? }
        str << columns.map { |col| col.header }.join("|") << "\n"
        str << columns.map { |col| col.separator }.join("|") << "\n"
      end

      data.each.with_index do |row, i|
        str << columns.map { |col| col.values[i] } << "\n"
      end

      str << "\n"
      str
    end

    class Column
      attr_reader :name, :options

      def initialize(name, options = {})
        @name, @options = name, options
        @values = []
      end

      def <<(value)
        @values << value
      end

      def header
        name.to_s.center(width)
      end

      def separator
        " " + ("-" * width) + (numeric? ? ":" : " ")
      end

      def values
        @formated_values ||= @values.map { |v| format(v) }
      end

      protected

      def width
        @width ||= [column_title, values].flatten.map(&:length).max
      end

      def numeric?
        @values.all? { |v| v.is_a?(Numeric) }
      end

      def format(value)
        str = case options[:format]
                when Proc   then options[:format].call(value)
                when String then (options[:format] % value)
                else        then value.to_s
              end

        str.send(justification, width)
      end

      def justification
        case options[:justify].to_s
        when "left"   then :ljust
        when "right"  then :rjust
        when "center" then :center
        else          then (numeric? ? :rjust : :ljust)
        end
      end
    end

  end
end
