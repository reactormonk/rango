# encoding: utf-8

require_relative "../../spec_helper"

require "rango"
require "logger"
Rango.logger = Logger.new("/dev/null")

require "rango/controller"
require "rango/mixins/action_args"

Rango::Router.use(:urlmap)

describe Rango::ActionArgsMixin do
  controller = Class.new(Rango::Controller) do
    include Rango::ActionArgsMixin

    def show(id)
      id
    end

    def create(post, msg = "Create successfuly")
      msg
    end

    def view_with_a_splat(*args)
    end

    def view_with_a_block(&block)
    end
  end

  def env_for_action(action, url = "/")
    env = Rack::MockRequest.env_for(url)
    env.merge("rango.controller.action" => action)
  end

  it "should raise argument error if there is a splat argument" do
    env = env_for_action(:view_with_a_splat)
    -> { controller.call(env) }.should raise_error(ArgumentError)
  end

  it "should raise argument error if there is a block argument" do
    env = env_for_action(:view_with_a_block)
    -> { controller.call(env) }.should raise_error(ArgumentError)
  end

  it "should raise argument error if there are arguments which doesn't match any key in params" do
    env = env_for_action(:show)
    -> { controller.call(env) }.should raise_error(ArgumentError)
  end

  it "should call a view with arguments matching params[argument]" do
    env = env_for_action(:show, "/?id=12")
    response = controller.call(env)
    response = Rack::Response.new(response)
    response.body.should eql("12")
  end

  it "should call a view with arguments matching params[argument]" do
    env = env_for_action(:show, "/?id=12&msg=hi") # nevadi ze je tam toho vic
    instance = controller.new(env)
    response = controller.call(env)
    response = Rack::Response.new(response)
    response.body.should eql(["neco", "message"])
  end

# NOTE: we can't use stubs because the stub redefine the method, so parameters of this method will be everytime just optional args and block
  it "should call a view with arguments matching params[argument]" do
    env = env_for_action(:create, "/?post=neco&msg=message")
    response = controller.call(env)
    response = Rack::Response.new(response)
    response.body.should eql(["neco", "message"])
  end

  it "should not require optinal arguments to be in params" do
    env = env_for_action(:create, "/?post=neco")
    response = controller.call(env)
    response = Rack::Response.new(response)
    response.body.should eql(["neco", "message"])
  end
end