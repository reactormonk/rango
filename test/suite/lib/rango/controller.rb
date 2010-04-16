require 'rango/controller'
BareTest.suite "Rango" do
  suite "Controller", :use => :rack_test do
    setup do
      @env = Rack::MockRequest.env_for("/")
      @env['rango.controller.action'] = "show"
      STRING = "Hello there, make me a sandwitch!"
      @controller_class = Class.new(Rango::Controller) do
        def show
          STRING
        end
      end
      @controller = @controller_class.new(@env)
    end

    suite "#invoke_action" do
      setup :exercise do
        @controller.run_action
      end
      assert "it invokes" do
        @controller.response.body == STRING
      end
    end

    suite "#run_action" do
      suite "errors" do
        setup :action, "no action given" do
          @action = nil
          @error = Rango::Controller::NoAction
        end
        setup :action, "an invalid action given" do
          @action = :foobaz
          @error = Rango::Exceptions::NotFound
        end
        setup :exercise do
          @env['rango.controller.action'] = @action
          @controller = Rango::Controller.new(@env)
        end
        assert "bails when :action" do
          raises(@error) { @controller.run_action }
        end
      end
      suite "else" do
        setup :exercise do
          @controller.run_action
        end
        assert "the action is invoked" do
          @controller.response.body == STRING
        end
      end
    end
  end
end
