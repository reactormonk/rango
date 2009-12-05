# encoding: utf-8

require_relative "../../spec_helper"

require "rango/project"
require "rango/mixins/render"

Project.settings.template_dirs = [File.join(STUBS_ROOT, "templates")]

describe Rango::RenderMixin do
  it "should work standalone" do
    Rango::RenderMixin.should respond_to(:render)
  end

  it "should work as a mixin" do
    controller = Class.new { include Rango::RenderMixin }
    controller.new.should respond_to(:render)
  end

  describe "#render" do
    include Rango::RenderMixin
    it "should take a path as the first argument" do
      body = render "test.html"
      body.should be_kind_of(String)
    end

    it "should take a context as the second argument" do
      context    = Object.new
      body       = render "context_id.html", context
      context_id = body.chomp.to_i
      context_id.should eql(context.object_id)
    end

    it "should take locals as the third argument" do
      context = Object.new
      body    = render "index.html", context, title: "Hi!"
      body.should match(/Hi\!/)
    end

    it "should take the second arguments as a locals if it's a hash and there is no third argument" do
      body = render "index.html", title: "Hi!"
      body.should match(/Hi\!/)
    end

    it "should raise TemplateNotFound if template wasn't found" do
      -> { render "idonotexist.html" }.should raise_error(Rango::Errors::TemplateNotFound)
    end
  end
end
