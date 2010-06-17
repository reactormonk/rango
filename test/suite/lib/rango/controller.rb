require 'rango/controller'
BareTest.suite "Rango" do
  suite "Controller", :use => :rack_test do
    setup do
      @env = Rack::MockRequest.env_for("/")
      @env['rango.controller.action'] = "show"
      @string = "Hello there, make me a sandwitch!"
      @controller_class = Class.new(Rango::Controller) do
        def show
          "Hello there, make me a sandwitch!"
        end
      end
      @controller = @controller_class.new(@env)
    end

    exercise "#invoke_action" do
      @controller.invoke_action(:show)
    end
    verify "the body responds to each" do
      @controller.response.body.respond_to?(:each)
    end
    verify "it sets body to @string" do
      equal(@string, Array(@controller.response.body).flatten.first)
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

        setup do
          @env['rango.controller.action'] = @action
          @controller = Rango::Controller.new(@env)
        end

        exercise "call!" do
          @controller.run_action
        end
        verify "bails when :action" do
          raises(@error)
        end
      end

      suite "else" do
        exercise "call!" do
          @controller.run_action
        end
        verify "the action is invoked" do
          equal(@string, Array(@controller.response.body).flatten.first)
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

      setup do
        Rango::Router.use(:usher)
        @controller_class = Class.new(Rango::Controller, &@block)
        @controller = @controller_class.new(@env)
      end

      exercise "call" do
        # I'm using call too here, doesn't matter.
        Rack::Lint.new(@controller_class).call(@env)
      end
      verify ":controller returns a valid rack response" do
        returned
      end

      exercise "#to_response" do
        Array(@controller.to_response[2]).first
      end
      verify "it handles :controller correctly" do
        returned =~ @check
      end

      teardown do
        Rango.environment = "test"
      end
    end

    suite "#params" do
      exercise "add" do
        @env.merge!('rango.router.params' => {'foo' => 'bar'})
      end
      verify "takes params from env['rango.router.params']" do
        equal({'foo' => 'bar'}, @controller.params)
      end
      verify "is a hash with indefferent access" do
        equal('bar', @controller.params[:foo])
      end
    end

  end
end
