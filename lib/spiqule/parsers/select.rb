module Spiqule
  module Parsers
    class Select < Base
      root(:statement)

      rule(:statement) do
        comment |
        select_statement |
        space?
      end

      rule(:select_statement) do
        select >>
        select_exprs.as(:select_exprs) >>
        from >>
        where.maybe >>
        group_by.as(:group_by).maybe >>
        having.as(:having).maybe >>
        order_by.as(:order_by).maybe >>
        limit.as(:limit).maybe >>
        offset.as(:offset).maybe >>
        #(for_update | lock_in_share_mode).maybe >>
        eol
      end

      rule(:select) do
        case_insensitive_str("select") >> space
      end

      rule(:select_exprs) do
        select_expr >> (comma >> space? >> select_expr).repeat >> space
      end

      rule(:select_expr) do
        distinct | field
      end

      rule(:from) do
        case_insensitive_str("from") >> space >> table >> space?
      end

      rule(:table_references) do
      end

      rule(:where) do
        case_insensitive_str("where") >> space >> where_conditions.as(:where_conditions) >> space?
      end

      rule(:group_by) do
        case_insensitive_str("group by") >> space >> fields >> space?
      end

      rule(:order_by) do
        case_insensitive_str("order by") >> space >> field >> space >> (case_insensitive_str("asc") | case_insensitive_str("desc")).as(:direction) >>
        (
          space? >> comma.maybe >> space? >> field >> space >> (case_insensitive_str("asc") | case_insensitive_str("desc")).as(:direction)
        ).repeat(1).maybe >>
        space?
      end

      rule(:having) do
        case_insensitive_str("having") >> space >> where_conditions >> space?
      end

      rule(:offset) do
        case_insensitive_str("offset") >> space >> integer.as(:offset_count) >> space?
      end

      rule(:limit) do
        case_insensitive_str("limit") >> space >> integer.as(:limit_count) >> space?
      end

      rule(:fields) do
        field >> (comma >> field).repeat
      end

      rule(:field) do
        (table >> dot).maybe >> (quoted_identifier | identifier).as(:field_name)
      end

      rule(:distinct) do
        case_insensitive_str("distinct").as(:distinct) >> space >> field
      end

      rule(:table) do
        (quoted_identifier | identifier).as(:table_name)
      end

      rule(:where_conditions) do
        where_condition.as(:lhs) >> space? >>
        (
          (bool_and | bool_or).as(:op) >> space >> where_conditions.as(:rhs)
        ).maybe
      end

      rule(:where_condition) do
        field >> space >> binop.as(:op) >> space >> value.as(:rhs)
      end

      # TODO
      rule(:joins) do
      end
    end
  end
end
