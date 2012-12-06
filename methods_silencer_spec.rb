require 'spec_helper'

class MethodsSilencerTest
  include MethodsSilencer

  def a!
  end

  def b!
  end
end

describe MethodsSilencerTest do
  let(:silenced_methods) { [:a, :b] }
  let(:silenced_exceptions) { [TypeError, IOError] }
  let(:exception_callback) { Proc.new {} }

  before do
    subject.class.silent_methods(silenced_methods, silenced_exceptions, &exception_callback)
  end

  it "responds to silenced_methods" do
    silenced_methods.each do |method|
      subject.should respond_to method
    end
  end

  it "doesn't raise silenced_exceptions" do
    silenced_exceptions.each do |e|
      subject.stub(:"#{silenced_methods.first}!").and_return { raise e }
      expect {
        subject.send(silenced_methods.first)
      }.to_not raise_exception
    end
  end

  it 'raises not listed exceptions' do
    subject.stub(:"#{silenced_methods.first}!").and_return { raise Exception }
    expect {
      subject.send(silenced_methods.first)
    }.to raise_exception Exception
  end
end
