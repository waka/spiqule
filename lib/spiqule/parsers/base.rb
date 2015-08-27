module Spiqule
  module Parsers
    class Base < Parslet::Parser
      # @return [Parslet::Atoms::Sequence] Case-insensitive pattern from a given string
      def case_insensitive_str(str)
        str.each_char.map {|char| match[char.downcase + char.upcase] }.reduce(:>>)
      end

      # @return [Parslet::Atoms::Repetation]
      def non(sequence)
        (sequence.absent? >> any).repeat
      end

      def single_quoted(value)
        str("'") >> value >> str("'")
      end

      def double_quoted(value)
        str('"') >> value >> str('"')
      end

      def back_quoted(value)
        str("`") >> value >> str("`")
      end

      rule(:newline) do
        str("\n") >> str("\r").maybe
      end

      rule(:space) do
        (match("\s") | comment).repeat(1)
      end

      rule(:space?) do
        space.maybe
      end

      rule(:comma) do
        str(',') >> space?
      end

      rule(:dot) do
        str('.')
      end

      rule(:lparen) do
        str('(') >> space?
      end

      rule(:rparen) do
        str(')') >> space?
      end

      rule(:eq) do
        str("=")
      end

      rule(:is) do
        str("is")
      end

      rule(:neq) do
        str('!=') | str('<>')
      end

      rule(:isnot) do
        case_insensitive_str("is") >> space >> case_insensitive_str("not")
      end

      rule(:gt) do
        str(">")
      end

      rule(:lt) do
        str("<")
      end

      rule(:geq) do
        str(">=")
      end

      rule(:leq) do
        str("<=")
      end

      rule(:btw) do
        case_insensitive_str("between")
      end

      rule(:like) do
        case_insensitive_str("like") >> space?
      end

      rule(:binop) do
        eq | neq | gt | lt | geq | leq | btw | like | isnot | is
      end

      rule(:delimiter) do
        str(";")
      end

      rule(:eol) do
        delimiter >> space?
      end

      rule(:integer) do
        match('[0-9]').repeat(1)
      end

      rule(:float) do
        integer >> str(".") >> integer.maybe
      end

      rule(:string) do
        single_quoted(
          (
            (str("\\") >> match(".")) | str("''") | match('[^\\\']')
          ).repeat
        ) |
        double_quoted(
          (
            (str("\\") >> match(".")) | str('""') | match('[^\\\"]')
          ).repeat
        )
      end

      rule(:identifier) do
        match('\w').repeat(1).as(:identifier)
      end

      rule(:quoted_identifier) do
        (
          back_quoted(match("[^`]").repeat(1))
        ).as(:quoted_identifier)
      end

      rule(:comment) do
        (
          (str("#") | str("--")) >> non(newline) >> newline
        ) |
        (
          str("/") >> space? >> str("*") >>
          ((str("*") >> space? >> str("/")).absent? >> any).repeat >> (str("*") >> space? >> str("/"))
        )
      end

      rule(:value) do
        (const | item).as(:value)
      end

      rule(:const) do
        float | integer | string | case_insensitive_str("null")
      end

      rule(:item) do
        function | identifier
      end

      rule(:function) do
        identifier.as(:function) >> space? >> lparen >> argments.as(:arguments) >> rparen
      end

      rule(:argments) do
        item.as(:item) >> (comma >> item.as(:item)).repeat
      end

      rule(:bool_and) do
        case_insensitive_str("and")
      end

      rule(:bool_or) do
        case_insensitive_str("or")
      end
    end
  end
end

