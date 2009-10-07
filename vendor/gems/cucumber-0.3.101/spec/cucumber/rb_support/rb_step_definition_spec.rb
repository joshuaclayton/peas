require File.dirname(__FILE__) + '/../../spec_helper'

require 'cucumber/ast'
require 'cucumber/step_mother'
require 'cucumber/rb_support/rb_language'

module Cucumber
  module RbSupport
    describe RbStepDefinition do
      before do      
        @step_mother = StepMother.new
        @step_mother.load_natural_language('en')
        @rb = @step_mother.load_programming_language('rb')
        @dsl = Object.new 
        @dsl.extend RbSupport::RbDsl
        @step_mother.before(nil)

        $inside = nil
      end
      
      def register
        @step_mother.register_step_definitions(@rb.step_definitions)
      end

      it "should allow calling of other steps" do
        @dsl.Given /Outside/ do
          Given "Inside"
        end
        @dsl.Given /Inside/ do
          $inside = true
        end
        register

        @step_mother.step_match("Outside").invoke(nil)
        $inside.should == true
      end

      it "should allow calling of other steps with inline arg" do
        @dsl.Given /Outside/ do
          Given "Inside", Ast::Table.new([['inside']])
        end
        @dsl.Given /Inside/ do |table|
          $inside = table.raw[0][0]
        end
        register

        @step_mother.step_match("Outside").invoke(nil)
        $inside.should == 'inside'
      end

      it "should raise Undefined when inside step is not defined" do
        @dsl.Given /Outside/ do
          Given 'Inside'
        end
        register

        lambda do
          @step_mother.step_match('Outside').invoke(nil)
        end.should raise_error(Undefined, 'Undefined step: "Inside"')
      end

      it "should allow forced pending" do
        @dsl.Given /Outside/ do
          pending("Do me!")
        end
        register

        lambda do
          @step_mother.step_match("Outside").invoke(nil)
        end.should raise_error(Pending, "Do me!")
      end

      it "should allow announce" do
        v = mock('visitor')
        v.should_receive(:announce).with('wasup')
        @step_mother.visitor = v
        @dsl.Given /Loud/ do
          announce 'wasup'
        end
        register
        
        @step_mother.step_match("Loud").invoke(nil)
      end
    
      def unindented(s)
        s.split("\n")[1..-2].join("\n").indent(-10)
      end
    
      it "should recognise quotes in name and make according regexp" do
        @rb.snippet_text('Given', 'A "first" arg').should == unindented(%{
          Given /^A "([^\\"]*)" arg$/ do |arg1|
            pending
          end
        })
      end

      it "should recognise several quoted words in name and make according regexp and args" do
        @rb.snippet_text('Given', 'A "first" and "second" arg').should == unindented(%{
          Given /^A "([^\\"]*)" and "([^\\"]*)" arg$/ do |arg1, arg2|
            pending
          end
        })
      end

      it "should not use quote group when there are no quotes" do
        @rb.snippet_text('Given', 'A first arg').should == unindented(%{
          Given /^A first arg$/ do
            pending
          end
        })
      end

      it "should be helpful with tables" do
        @rb.snippet_text('Given', 'A "first" arg', Cucumber::Ast::Table).should == unindented(%{
          Given /^A "([^\\"]*)" arg$/ do |arg1, table|
            # table is a Cucumber::Ast::Table
            pending
          end
        })
      end
    end
  end
end
