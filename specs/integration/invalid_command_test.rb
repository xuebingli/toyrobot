require_relative '../spec_helper'
require 'parser'

class InvalidCommandTest < Minitest::Unit::TestCase
  def setup
    @p = Parser.new
  end

  def test_ignore_invalid_command_in_the_beginning
    @p.parse 'INVALID'
    @p.parse 'PLACE 2,4,NORTH'
    @p.parse 'LEFT'
    @p.parse 'MOVE'
    lambda { @p.parse 'REPORT' }.must_output "1,4,WEST\n"
  end

  def test_ignore_invalid_command_in_the_middle
    @p.parse 'PLACE 2,4,NORTH'
    @p.parse 'INVALID'
    @p.parse 'LEFT'
    @p.parse 'MOVE'
    lambda { @p.parse 'REPORT' }.must_output "1,4,WEST\n"
  end

  def test_ignore_invalid_command_in_the_end
    @p.parse 'PLACE 2,4,NORTH'
    @p.parse 'LEFT'
    @p.parse 'MOVE'
    @p.parse 'INVALID'
    lambda { @p.parse 'REPORT' }.must_output "1,4,WEST\n"
  end
end