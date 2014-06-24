require "table_printer/version"

module TablePrinter

  def print_table(data, &config)
    Table.new(&config).render(data)
  end

  class Table
    attr_reader :columns, :data

    def initialize(data = [], &block)
      @data = data
      @columns = []
      instance_eval(block) if block_given?
    end

    def column(*names)
      options = names.extract_options!
      names.each do |name|
        columns << Column.new(name, options)
      end
    end

    def render(data = @data)
      if columns.empty?
        r = data.first
        if r.respond_to? :keys
          r.keys.each { |name| columns << Column.new(name) }
        else
          r.size.times { columns << Column.new(nil) }
        end
      end

      data.each do |row|
        if row.respond_to? :keys
          row.each do |name, value|
            columns.detect { |col| col.name == name }.values << value
          end
        else
          row.each.with_index do |value, i|
            columns[i].values << value
          end
        end
      end

      str = ""
      if columns.any? { |col| col.has_header? }
        str << columns.map { |col| col.header }.join("|") << "\n"
        str << columns.map { |col| col.separator }.join("|") << "\n"
      end

      data.each.with_index do |row, i|
        str << columns.map { |col| col.justified_values[i] }.join("|") << "\n"
      end

      str << "\n"
      str
    end

    class Column
      attr_reader :name, :values, :options

      def initialize(name, options = {})
        @name, @options = name, options
        @values = []
      end

      def has_header?
        !name.nil?
      end

      def header
        title.center(width)
      end

      def separator
        case justification
          when :ljust  then l, r = " ", " "
          when :rjust  then l, r = " ", ":"
          when :center then l, r = ":", ":"
        end
        [l, "-" * width, r].join
      end

      def formated_values
        @formated_values ||= @values.map { |v| format(v) }
      end

      def justified_values
        @justified_values ||= formated_values.map { |v| v.send(justification, width) }
      end

      def title
        name.to_s
      end

      protected

      ### FIXME: values is expecting to know the width, err: stack level too deep
      def width
        @width ||= [title, formated_values].flatten.map(&:length).max
      end

      def numeric?
        false
        #@values.all? { |v| v.is_a?(Numeric) }
      end

      def format(value)
        case options[:format]
          when Proc   then options[:format].call(value)
          when String then (options[:format] % value)
          else value.to_s
        end
      end

      def justification
        case options[:justify].to_s
          when "left"   then :ljust
          when "right"  then :rjust
          when "center" then :center
          else (numeric? ? :rjust : :ljust)
        end
      end
    end

  end
end
