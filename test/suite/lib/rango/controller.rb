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

    suite "#to_response" do
      setup :controller, "a silent controller" do
        @block = proc do
          def show
            "make me a cucumber sandwitch"
          end
        end
        @check = /cucumber/
      end
      setup :controller, "a controller raising a redirection" do
        @block = proc do
          def show
            raise Rango::Exceptions::Redirection.new("/foo", 303)
          end
        end
        @check = /Please follow/
      end
      setup :controller, "a controller raising an HttpError" do
        @block = proc do
          def show
            raise Rango::Exceptions::InternalServerError
          end
        end
        @check = /Internal Server Error/
      end
      setup :controller, "a controller raising an Exception in production" do
        Rango.environment = "production"
        @block = proc do
          def show
            raise "sudo make me a sandwitch"
          end
        end
        @check = /Application Error/
      end

      setup :exercise do
        Rango::Router.use(:usher)
        @controller_class = Class.new(Rango::Controller, &@block)
        @controller = @controller_class.new(@env)
      end

      assert ":controller returns a valid rack response" do
        # I'm using call too here, doesn't matter.
        Rack::Lint.new(@controller_class).call(@env)
      end

      assert "it handles :controller correctly" do
        Array(@controller.to_response[2]).first =~ @check
      end

      teardown do
        Rango.environment = "test"
      end
    end

  end
end
