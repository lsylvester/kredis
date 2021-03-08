require "test_helper"
require 'models/contact'

class UniqueListTest < ActiveSupport::TestCase
  setup { @list = Kredis.unique_list "myuniquelist" }

  test "append" do
    @list.append(%w[ 1 2 3 ])
    @list.append(%w[ 1 2 3 4 ])
    assert_equal %w[ 1 2 3 4 ], @list.elements

    @list << "5"
    assert_equal %w[ 1 2 3 4 5 ], @list.elements
  end

  test "prepend" do
    @list.prepend(%w[ 1 2 3 ])
    @list.prepend(%w[ 1 2 3 4 ])
    assert_equal %w[ 4 3 2 1 ], @list.elements
  end

  test "append nothing" do
    @list.append(%w[ 1 2 3 ])
    @list.append([])
    assert_equal %w[ 1 2 3 ], @list.elements
  end

  test "prepend nothing" do
    @list.prepend(%w[ 1 2 3 ])
    @list.prepend([])
    assert_equal %w[ 3 2 1 ], @list.elements
  end

  test "typed as integers" do
    @list = Kredis.unique_list "mylist", typed: :integer

    @list.append [ 1, 2 ]
    @list << 2
    assert_equal [ 1, 2 ], @list.elements

    @list.remove(2)
    assert_equal [ 1 ], @list.elements
  end

  test "typed as global_ids" do
    @list = Kredis.unique_list "idlist", typed: :global_id

    @list.append Contact.find(2)
    @list.append Contact.find(1)

    assert_equal [ Contact.find(2), Contact.find(1) ], @list.elements
  end
end
