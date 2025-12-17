# frozen_string_literal: true

module Auzon
  module Integration
    # Helper methods for API controllers.
    module ControllerApiMethods
      private

      # Run `obj.call` and then execute code block if obj result is successful,
      # otherwise render errors from obj.
      # @example
      #   obj = Users::Forms::Accounts::Create.new_from_params(params[:account])
      #   call_and_then(obj) { |_obj| render_object(Users::Serializers::Account, obj.object) }
      #   # Here `obj` passed into block as `_obj`.
      # @param obj [Base::ActiveObject]
      # @yieldparam obj [Base::ActiveObject]
      # @yieldreturn [void]
      # @return [void]
      def call_and_then(obj)
        obj.call.success? ? yield(obj) : render_error(errors: obj.errors)
      end

      # Return response with error objects.
      # @example
      #   render_error(message: "Unauthenticated")
      #   render_error(errors: form.errors)
      #   render_error(message: "Unauthenticated", errors: form.errors)
      # @param message [String]
      # @param errors [Hash-like] Errors in form: `{attribute: ["message"]}`
      # @return [void]
      def render_error(message: "", errors: nil)
        render json: {error: {errors:, message:}}, status: :unprocessable_entity
      end

      # Return response with requested object.
      # @example
      #   render_object(Users::Serializers::Account, form.object, jwt: form.jwt)
      # @param serializer [Blueprinter::Base]
      # @param object [Object] Object for serialization
      # @param serializer_args [Hash] Options for serializer
      # @return [void]
      def render_object(serializer, object, **serializer_args)
        render json: {object: serialize_result(serializer, object, **serializer_args)}
      end

      # Return response with requested objects.
      # @example
      #   accounts = Users::Account.all.to_a
      #   count = accounts.size
      #   render_objects(Users::Serializers::Account, objects: accounts, total: count)
      # @param serializer [Blueprinter::Base]
      # @param objects [Array] Array of objects for serialization
      # @param total [Integer] Total amount of existing records (may be more than `objects.size`)
      # @param serializer_args [Hash] Options for serializer
      # @return [void]
      def render_objects(serializer, objects:, total:, **serializer_args)
        render json: {objects: serialize_result(serializer, objects, **serializer_args), total:}
      end

      # Return response with error objects, but with successful status.
      # @example
      #   render_warning(errors: form.errors)
      # @param message [String]
      # @param errors [Hash-like] Errors in form: `{attribute: ["message"]}`
      # @return [void]
      def render_warning(message: "", errors: nil)
        render json: {warning: {errors:, message:}}, status: :accepted
      end

      # @example
      #   serialize_result(Users::Serializers::Account, [current_user], jwt: form.jwt)
      # @param serializer [Blueprinter::Base]
      # @param result [Object | Array<Object>] Object or array of objects for serialization
      # @param kwargs [Hash] Options for serializer
      # @return [Hash | Array<Hash>] Returns Array if result is Array, otherwise returns Hash
      def serialize_result(serializer, result, **kwargs)
        serializer.render_as_hash(result, current_user:, url_options:, **kwargs)
      end
    end
  end
end
