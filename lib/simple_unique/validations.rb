require 'simple_unique/validations/uniqueness'

module AWS
  module Record

    module Validations

      # Validates whether the value of the specified attributes are unique across 
      # the system. Useful for making sure that only one user can be named “foo”.
      #
      #   class Person < AWS::Record::Model
      #     validates_uniqueness_of :user_name
      #   end
      #
      # It can also validate whether the value of the specified attributes are unique based on a scope parameter:
      #
      #   class Person < AWS::Record::Model
      #     validates_uniqueness_of :user_name, :scope => :account_id
      #   end
      #
      # Or even multiple scope parameters. For example, making sure that a teacher can only be on the schedule once
      # per semester for a particular class.
      #
      #   class TeacherSchedule < AWS::Record::Model
      #     validates_uniqueness_of :teacher_id, :scope => [:semester_id, :class_id]
      #   end
      #
      # When the record is created, a check is performed to make sure that no record exists in the database
      # with the given value for the specified attribute (that maps to a column). When the record is updated,
      # the same check is made but disregarding the record itself.
      #
      # Configuration options:
      # * <tt>:message</tt> - Specifies a custom error message (default is: "has already been taken").
      # * <tt>:scope</tt> - One or more columns by which to limit the scope of the uniqueness constraint.
      # * <tt>:case_sensitive</tt> - Always +true+.  SimpleDB does not support case insensitive search.
      # * <tt>:allow_nil</tt> - Always +true+.
      # * <tt>:allow_blank</tt> - Always +true+.
      # * <tt>:if</tt> - Specifies a method, proc or string to call to determine if the validation should
      #   occur (e.g. <tt>:if => :allow_validation</tt>, or <tt>:if => Proc.new { |user| user.signup_step > 2 }</tt>).
      #   The method, proc or string should return or evaluate to a true or false value.
      # * <tt>:unless</tt> - Specifies a method, proc or string to call to determine if the validation should
      #   not occur (e.g. <tt>:unless => :skip_validation</tt>, or
      #   <tt>:unless => Proc.new { |user| user.signup_step <= 2 }</tt>). The method, proc or string should
      #   return or evaluate to a true or false value.
      #
      # === Concurrency and integrity
      #
      # Using this validation method in conjunction with AWS::Record::Model#save
      # does not guarantee the absence of duplicate record insertions, because
      # uniqueness checks on the application level are inherently prone to race
      # conditions. For example, suppose that two users try to post a Comment at
      # the same time, and a Comment's title must be unique. At the database-level,
      # the actions performed by these users could be interleaved in the following manner:
      #
      #               User 1                 |               User 2
      #  ------------------------------------+--------------------------------------
      #  # User 1 checks whether there's     |
      #  # already a comment with the title  |
      #  # 'My Post'. This is not the case.  |
      #  SELECT * FROM comments              |
      #  WHERE title = 'My Post'             |
      #                                      |
      #                                      | # User 2 does the same thing and also
      #                                      | # infers that his title is unique.
      #                                      | SELECT * FROM comments
      #                                      | WHERE title = 'My Post'
      #                                      |
      #  # User 1 inserts his comment.       |
      #  INSERT INTO comments                |
      #  (title, content) VALUES             |
      #  ('My Post', 'hi!')                  |
      #                                      |
      #                                      | # User 2 does the same thing.
      #                                      | INSERT INTO comments
      #                                      | (title, content) VALUES
      #                                      | ('My Post', 'hello!')
      #                                      |
      #                                      | # ^^^^^^
      #                                      | # Boom! We now have a duplicate
      #                                      | # title!
      #
      # To guard against duplicates you should create a process to periodically
      # scan your data and take appropriate action when duplicates are found.  (Ick!)
      # This means that this validation is useful only in systems where the data creation
      # events that trigger it are few and far between (relatively speaking).
      def validates_uniqueness_of *args
        validators << UniquenessValidator.new(self, *args)
      end

    end

  end
end
